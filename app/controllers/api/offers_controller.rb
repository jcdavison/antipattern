class Api::OffersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def decision_registered
    offer = Offer.find_by(id: params[:id])
    accept_status = !offer.nil? && !offer.presented? ? offer.accepted? : nil
    render json: { accept_status: accept_status }
  end

  def create
    review_request_id = params[:reviewRequestId].to_i
    offer = Offer.new review_request_id: review_request_id, user_id: current_user.id
    if offer.save
      render json: { offer: offer.to_json }, status: 200
    else
      head :forbidden
    end
  end

  def update
    offer = Offer.find_by_id(params[:id])
    if offer
      if offer.register_decision params[:decision]
        render json: { offer_id: offer.id, accepted: offer.accepted? }, status: 200
      else
        head :forbidden
      end
    else
      head :forbidden
    end
  end

  def has_offered
    review_request = Offer.find_by(user_id: current_user.id, review_request_id: params[:id])
    has_offered = !review_request.nil?
    render json: { has_offered: has_offered }, status: 200
  end

end
