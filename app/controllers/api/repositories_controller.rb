class Api::RepositoriesController < ApplicationController
  def index
    repos = OCTOCLIENT.get("/users/#{current_user.github_username}/repos", per_page: 100)
    repo_names = repos.map {|repo, index| {text: repo[:name], id: repo[:name]} }
    render json: { repos: repo_names }
    rescue
      render json: { repos: [] }
  end
end
