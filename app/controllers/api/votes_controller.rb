class Api::VotesController < ApplicationController
  before_filter :authenticate_user!, only: [:create]

  def create
    opts = {  value: params[:vote][:value], 
              voteable_type: params[:vote][:voteable_type],
              voteable_id: params[:vote][:voteable_id],
              user_id: current_user.id}
    vote = Vote.new(opts)
    vote.save
    render json: { content: {vote: vote.to_waffle.attributes! } }, status: 200
    rescue 
      render json: { content: 'not ok'}, status: 401
  end
end
