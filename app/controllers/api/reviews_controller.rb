class Api::ReviewsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  respond_to :json

  def index
    @code_reviews = ReviewRequest.all_active
    render 'api/reviews/reviews'
  end

  def create
    @review_request = ReviewRequest.new(code_review_params.merge(user_id: current_user.id))
    if @review_request.save
      render 'api/reviews/create'
    else
      head :forbidden
    end
  end

  def owned_by
    review_request = ReviewRequest.find_by(user_id: current_user.id, id: params[:id])
    owned_by = !review_request.nil?
    render json: { owned_by: owned_by}
  end

  def update
    @code_review = ReviewRequest.find_by(user_id: current_user.id, id: params[:code_review][:id])
    if @code_review.update_attributes(code_review_params)
      render 'api/reviews/update'
    else
      head :forbidden
    end
  end

  def destroy
    @code_review = ReviewRequest.find_by(id: params[:id])
    @code_review.deleted = true
    if @code_review.save
      head :ok
    else
      head :forbidden
    end
  end

  private

    def code_review_params
      params.require(:code_review).compact.permit(:id, :title, :detail, :value)
    end
end
