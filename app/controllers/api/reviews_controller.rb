class Api::ReviewsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  respond_to :json

  def index
    @code_reviews = CodeReview.all_active
    render 'api/reviews/reviews'
  end

  def show
    @code_review = CodeReview.find(params[:id])
    render 'api/reviews/show'
  end

  def create
    @code_review = CodeReview.new(code_review_params.merge(user_id: current_user.id))
    if @code_review.save
      @members_notified = @code_review.notify_subscribers
      render 'api/reviews/create'
    else
      head :forbidden
    end
  end

  def owned_by
    code_review = CodeReview.find_by(user_id: current_user.id, id: params[:id])
    owned_by = !code_review.nil?
    render json: { owned_by: owned_by}
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
      params.require(:code_review).compact.permit(:id, :title, :detail)
    end
end
