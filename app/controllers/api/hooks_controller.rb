class Api::HooksController < ApplicationController
  protect_from_forgery except: [:consume]
  before_filter :authorized_octo_hook?

  def consume
    update_collaborators_cache params[:repo_name]
    render json: 'ok', status: 200
  end

  private
    def update_collaborators_cache repo
      CodeReview.where(repo: repo).each {|code_review| code_review.set_collaborators }
    end
end
