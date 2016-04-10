class Api::CommentsSentimentsController < ApplicationController
  before_filter :authenticate_user!, only: [:create]

  def show
    comment = Comment.find(params[:id])
    render json: { comment: comment, sentiments_vote_summary: comment.sentiments_vote_summary(set_user_context(current_user)) }
  end

  def create
    sentiment = Sentiment.find_by_name params[:sentiment]
    vote_opts = { voteable_type: 'Comment',
                  voteable_id: params[:commentId],
                  value: params[:value].to_i,
                  user_id: current_user.id,
                  sentiment_id: sentiment.id }
    CommentSentimentVoter.register_vote(vote_opts, current_user)
    render json: { foo: 'bar'}, status: 200
  end

  private

  def set_user_context user
    user.nil? ? OpenStruct(id: 0) : user
  end
end
