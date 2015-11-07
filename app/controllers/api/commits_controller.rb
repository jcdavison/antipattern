class Api::CommitsController < ApplicationController
  def index
    owner = params[:entity][:value]
    repo = params[:repo]
    branch = params[:branch]
    commits = OCTOCLIENT.get("/repos/#{owner}/#{repo}/commits?sha=#{branch}")
    commits_blob = commits.map {|c| { text: c[:commit][:message], id: c[:sha] } }
    render json: { commits: commits_blob }
    rescue
      render json: { branches: [] }
  end
end
