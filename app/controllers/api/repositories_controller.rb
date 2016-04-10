class Api::RepositoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    client = build_octo_client current_user.octo_token
    request_url = repo_url params[:entityType], params[:entityValue]
    repos = client.get(request_url, per_page: 100)
    repo_names = repos.map {|repo, index| {text: repo_display_text(repo), id: repo[:name], private: repo[:private], repoId: repo[:id], fullname: repo[:full_name]} }
    render json: { repos: repo_names.sort_by {|r| r[:text].downcase } }
    rescue
      render json: { repos: [] }
  end

  private
    def repo_url entity_type, entity_value
      if entity_type == 'user'
        '/user/repos?affiliation=owner'
      elsif entity_type == 'orgs'
        "/orgs/#{entity_value}/repos"
      end
    end

    def repo_display_text repo
      if repo[:private]
        "#{repo[:name]} | PRIVATE REPO"
      else
        repo[:name]
      end
    end
end
