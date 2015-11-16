include OctoHelper
include StructuralHelper
include QueryHelper

class Api::ReviewsController < ApplicationController

  PATCH_INFO_REGEXP = /@@.+@@/
  before_filter :authenticate_user!, except: [:index, :show]
  respond_to :json

  def index
    @code_reviews = all_active_code_reviews
    render json: {codeReviews: @code_reviews}
  end

  def show
    @code_review = CodeReview.preload(:user).find params[:id]
    @code_review_owner = @code_review.user.to_waffle.attributes!
    commit_blob = build_commit_blob(OCTOCLIENT.get(commit_url(@code_review))) 
    github_comment_colletion = grab_comments(@code_review, OCTOCLIENT).map {|e| e.to_attrs }
    comments_by_github_id = change_key(github_comment_colletion, :id, :github_id)
    comments = save_and_associate({find_key: :github_id, objects: comments_by_github_id, attributes: [:body, :github_id], class: 'Comment', parent: @code_review})
    binding.pry
    @commit_blob = inject_comments_into comments_by_github_id, commit_blob
    @commit_blob[:info].merge!({repo: @code_review.repo, commitSha: @code_review.commit_sha})
    render json: {commit: @commit_blob, codeReviewOwner: @code_review_owner, codeReviewId: @code_review.id}
  end

  def create
    @code_review = CodeReview.new(code_review_params.merge(user_id: current_user.id))
    topic_list = tagize_topics params[:code_review][:topics]
    @code_review.topic_list = topic_list
    if @code_review.save
      Notifier.delay.new(code_review: @code_review)
      render 'api/reviews/create'
    else
      head :forbidden
    end
  end

  def owned_by
    code_review = CodeReview.find_by(user_id: current_user.id, id: params[:id])
    owned_by = ! code_review.nil?
    render json: { owned_by: owned_by }
  end

  def update
    @code_review = CodeReview.find_by(user_id: current_user.id, id: params[:code_review][:id])
    if @code_review.update_attributes(code_review_params)
      render 'api/reviews/update'
    else
      head :forbidden
    end
  end

  def destroy
    @code_review = CodeReview.find_by(id: params[:id])
    @code_review.deleted = true
    if @code_review.save
      head :ok
    else
      head :forbidden
    end
  end

  private
    def code_review_params
      params.require(:code_review).compact.permit(:context, :repo, :commit_sha, :title, :author, :branch)
    end

    def tagize_topics enum_data
      enum_data.join(', ')
    end
end
