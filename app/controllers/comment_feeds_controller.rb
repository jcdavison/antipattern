class CommentFeedsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def show
    @comment_feed = CommentFeed.find_by_url_slug(params[:url_slug]).to_waffle.attributes!
  end
end
