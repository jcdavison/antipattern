class Api::CommitsController < ApplicationController
  before_action :authenticate_user!

  def index
    opts = {repo_id: params[:repo_id], branch: params[:branch]}
    commits = OCTOCLIENT.get octo_commits_url(opts)
    commits_blob = commits.map {|c| { text: c[:commit][:message], id: c[:sha] } }
    render json: { commits: commits_blob }
    rescue
      render json: { commits: [] }, status: 401
  end
end
