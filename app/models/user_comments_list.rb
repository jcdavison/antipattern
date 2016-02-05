include OctoHelper
include StructuralHelper
include ObjHelper

class UserCommentsList
  attr_accessor :client, :org_names, :org_repos, :user_repos, :all_repos, :comment_objects
  def initialize opts
    @client = opts[:client]
    @org_names = get_user_orgs
    @org_repos = get_org_repos
    @user_repos = get_user_repos
    @all_repos = nil
    merge_user_org_repos
    @comment_objects = get_all_repo_comments
  end

  def get_user_orgs
    client.get("/user/orgs", per_page: 100).map do |org|
      org[:login]
    end
  end

  def get_org_repos
    org_names.inject([]) do |collection, org_name|
      client.get(repos_url('orgs', org_name)).each do |repo|
        collection.push({name: repo[:name], id: repo[:id]})
      end
      collection
    end
  end

  def get_user_repos
    user_repos_url = repos_url 'user'
    client.get(user_repos_url, per_page: 100).map do |repo|
      { name: repo[:name], id: repo[:id] }
    end
  end

  def merge_user_org_repos
    self.all_repos = user_repos.push(org_repos).flatten
  end

  def get_all_repo_comments
    self.comment_objects = sort_repo_comments get_comments({repos: all_repos})
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
