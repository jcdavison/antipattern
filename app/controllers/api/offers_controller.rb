class Api::OffersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    review_request_id = params[:reviewRequestId].to_i
    offer = Offer.new review_request_id: review_request_id, user_id: current_user.id
    # if offer.save
    #   render json: { offer: offer.to_json }, status: 200
    # else
    head :forbidden
    # end
  end

end
