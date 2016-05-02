include OctoHelper
include QueryHelper
include ObjHelper
include StructuralHelper

class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @comment_threads = Rails.cache.read current_user.comments_cache_key
    if params['updateCache'] == 'true' || @comment_threads.nil?
      @comment_threads = 'in_progress'
      opts = {user_comments_cache_key: current_user.comments_cache_key, octo_token: current_user.octo_token, user_id: current_user.id}
      Delayed::Job.enqueue UserCommentsListWorker.new(opts)
    end
  end

  def show

  end
end
