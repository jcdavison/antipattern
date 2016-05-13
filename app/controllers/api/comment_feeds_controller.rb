class Api::CommentFeedsController < ApplicationController
  before_filter :authenticate_user!

  def index
    comment_feeds = User.includes(:comment_feeds).find(current_user.id).comment_feeds.where(deleted: false).map {|comment_feed| comment_feed.to_waffle.attributes! }
    render json: {commentFeeds: comment_feeds }
  end

  def create
    feed_details = { user_id: current_user.id,
                        repository: params[:repository],
                        github_entity: params[:github_entity] }
    comment_feed = CommentFeed.build_from(feed_details)
    render json: { content: 'happy trails' }, status: 200
    rescue 
      render json: { content: 'not ok'}, status: 401
  end

  def destroy
    CommentFeed.find_by_url_slug(params[:url_slug]).update_attributes(deleted: true)
    render json: { content: 'happy trails' }, status: 200
    rescue 
      render json: { content: 'not ok'}, status: 401
  end
end
