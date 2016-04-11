class Api::CommentsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :index]

  def show
    comment = Comment.find_by github_id: params[:github_id]
    current_user_vote = current_user ? comment.votes.select {|c| c.user_id == current_user.id }.first : nil
    render json: { comment: comment.to_waffle.attributes!, currentUserVote: current_user_vote}, status: 200
    rescue 
      render json: { content: 'not ok'}, status: 401
  end

  def create
    comment = params[:comment]
    post_comment current_user, comment
    render json: { content: 'ok'}, status: 200
    rescue 
      render json: { content: 'not ok'}, status: 401
  end

  def index
    @comment_threads = Rails.cache.read current_user.comments_cache_key
    if params['updateCache'] == 'true' || @comment_threads.nil?
      @comment_threads = 'in_progress'
      opts = {user_comments_cache_key: current_user.comments_cache_key, octo_token: current_user.octo_token, user_id: current_user.id}
      Delayed::Job.enqueue UserCommentsListWorker.new(opts)
    end
    render json: { commentThreads: @comment_threads }
  end

  private
    def post_comment user, comment
      client = build_octo_client user.octo_token
      client.post comment_post_url(comment), postable_comment(comment)
    end

    def postable_comment comment
      { body: comment[:body], path: comment[:path], position: comment[:position] }
    end

    def comment_post_url comment
      "/repos/#{comment[:repo_owner]}/#{comment[:repo]}/commits/#{comment[:sha]}/comments"
    end
end
