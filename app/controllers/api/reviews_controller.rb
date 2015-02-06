class Api::ReviewsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    @review_request = ReviewRequest.new(review_request_params.merge(user_id: current_user.id))
    if @review_request.save
      render 'api/reviews/review'
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

  private

    def code_review_params
      params.require(:code_review).permit(:title, :detail, :value)
    end
end
