class Api::RepositoriesController < ApplicationController
  def index
    client = build_octoclient current_user.octo_token
    request_url = repo_url params[:entityType], params[:entityValue]
    repos = client.get(request_url, per_page: 100)
    repo_names = repos.map {|repo, index| {text: repo[:name], id: repo[:name], private: repo[:private]} }
    render json: { repos: repo_names }
    rescue
      render json: { repos: [] }
  end

  private
    def repo_url entity_type, entity_value
      if entity_type == 'user'
        '/user/repos'
      elsif entity_type == 'orgs'
        "/orgs/#{entity_value}/repos"
      end
    end
end
