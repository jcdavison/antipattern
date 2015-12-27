class Api::BranchesController < ApplicationController
  def index
    opts = { repo_id: params[:repo_id] }
    branches = OCTOCLIENT.get(octo_branches_url(opts))
    branch_names = branches.map {|branch| {text: branch[:name], id: branch[:name]} } 
    render json: { branches: branch_names }
    rescue
      render json: { branches: [] }
  end
end
