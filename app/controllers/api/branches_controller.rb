class Api::BranchesController < ApplicationController
  def index
    owner = params[:entity][:value]
    repo = params[:repo]
    branches = OCTOCLIENT.get("/repos/#{owner}/#{repo}/branches")
    branch_names = branches.map {|branch| {text: branch[:name], id: branch[:name]} } 
    render json: { branches: branch_names }
    rescue
      render json: { branches: [] }
  end
end
