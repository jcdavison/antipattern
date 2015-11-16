class Api::VotesController < ApplicationController
  before_filter :authenticate_user!, only: [:create]

  def create
    opts = {  voteable_type: params[:vote][:voteable_type],
              voteable_id: params[:vote][:voteable_id].to_i,
              user_id: current_user.id}
    vote = Vote.vote_of_record_for opts
    if vote
      vote.value = params[:vote][:value].to_i
    else 
      vote = Vote.new opts
      vote.value = params[:vote][:value].to_i
    end
    vote.save
    render json: { content: {vote: vote.to_waffle.attributes! } }, status: 200
    rescue 
      render json: { content: 'not ok'}, status: 401
  end
end
