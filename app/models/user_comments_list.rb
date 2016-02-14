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
    @all_comments = get_all_repo_comments
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
      (Time.now - repo[:updated_at]) < 30.days
    end
  end

  def get_all_repo_comments
    self.comment_objects = sort_repo_comments get_comments({repos: recently_updated_repos})
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
      comments = client.get(repo_all_comments_url(repo_id: repo[:id]))
      unless comments.empty?
        comments.each do |comment|
          comment[:user] = comment[:user].to_h
          collection.push({ comment: comment.to_h, repo: repo} )
        end
      end
      collection
    end
  end

  def repos_url entity_type, org_id = nil
    if entity_type == 'user'
      '/user/repos?affiliation=owner'
    elsif entity_type == 'orgs'
      "/orgs/#{org_id}/repos"
    end
  end
end
