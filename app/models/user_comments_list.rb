include OctoHelper
include StructuralHelper
include ObjHelper

class UserCommentsList
  attr_accessor :client, :org_names, :org_repos, 
                :user_repos, :all_repos, :comment_objects,
                :recently_updated_repos, :all_comments

  def initialize opts
    @client = build_octo_client opts[:octo_token]
    clear_user_cache opts[:user_comments_cache_key]
    set_cache_in_progress opts[:user_comments_cache_key]
    @org_names = get_user_orgs
    @org_repos = get_org_repos
    @user_repos = get_user_repos
    @all_repos = self.user_repos.push(org_repos).flatten
    @recently_updated_repos = select_recently_updated_repos
    @all_comments = get_all_repo_comments(user_id: opts[:user_id])
    @comment_objects = group_by_commit self.all_comments
    write_to_user_cache opts[:user_comments_cache_key]
  end

  def write_to_user_cache key
    Rails.cache.write key, self.comment_objects
  end

  def clear_user_cache key
    Rails.cache.delete key
  end

  def set_cache_in_progress key
    Rails.cache.write key, 'in_progress'
  end

  def get_user_orgs
    client.get("/user/orgs", per_page: 100).map do |org|
      org[:login]
    end
  end

  def get_org_repos
    org_names.inject([]) do |collection, org_name|
      client.get(repos_url('orgs', org_name)).each do |repo|
        collection.push({name: repo[:name], id: repo[:id], updated_at: repo[:updated_at]})
      end
      collection
    end
  end

  def get_user_repos
    user_repos_url = repos_url 'user'
    client.get(user_repos_url, per_page: 100).map do |repo|
      { name: repo[:name], id: repo[:id], updated_at: repo[:updated_at]}
    end
  end

  def select_recently_updated_repos
    all_repos.select do |repo|
      (Time.now - repo[:updated_at]) < 45.days
    end
  end

  def get_all_repo_comments opts
    self.comment_objects = sort_repo_comments get_comments({repos: recently_updated_repos, user_id: opts[:user_id]})
  end

  def group_by_commit comments
    comments.inject({}) do |collection, comment|
      comment_key = comment[:comment][:commit_id]
      if collection[comment_key]
        collection[comment_key].push comment
      else
        collection[comment_key] = [comment]
      end
      collection
    end
  end

  def sort_repo_comments comment_objects
    comment_objects.sort_by do |obj|
      obj[:comment][:updated_at] ? obj[:comment][:updated_at] : obj[:comment][:created_at]
    end.reverse
  end

  def get_comments opts
    opts[:repos].inject([]) do |collection, repo|
      raw_comments = client.get(repo_all_comments_url(repo_id: repo[:id]))
      unless raw_comments.empty?
        change_key(raw_comments, :id, :github_id)
        raw_comments.each do |raw_comment|
          code_review = CodeReview.find_by_commit_sha(raw_comment[:commit_id])

          if code_review.nil?
            code_review_opts = { commit_sha: raw_comment[:commit_id], repo_id: repo[:id], repo: repo[:name], user_id: opts[:user_id] }
            CodeReview.find_or_create_by code_review_opts
            code_review = CodeReview.find_by_commit_sha(raw_comment[:commit_id])
          end

          comment = save_comment(raw_comment, code_review)
          raw_comment[:user] = raw_comment[:user].to_h

          # comment_obj needs to be encapsulated and managed by something other than this method
          comment_obj_for_client = { comment: raw_comment.to_h, 
                                     repo: repo, 
                                     code_review_id: code_review.id, 
                                     sentiments: comment.sentiments_as_opts,
                                     votes: comment.votes }
          collection.push( comment_obj_for_client )
        end
      end
      collection
    end
  end

  def build_comment_obj_for_client opts

  end

  def repos_url entity_type, org_id = nil
    if entity_type == 'user'
      '/user/repos?affiliation=owner'
    elsif entity_type == 'orgs'
      "/orgs/#{org_id}/repos"
    end
  end

  def save_comment comment, code_review
    save_and_associate({find_key: :github_id, objects: [comment], attributes: [:body, :github_id], class: 'Comment', parent: code_review})[:created_objs].first
  end
end
