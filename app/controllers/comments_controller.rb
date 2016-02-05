include OctoHelper
include QueryHelper
include ObjHelper
include StructuralHelper

class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def index
    cached_comment_objects = Rails.cache.read(user_comments_cache_key(current_user))
    if cached_comment_objects == nil || params['updateCache'] == 'true'
      client = build_octoclient current_user.octo_token
      @comment_list = UserCommentsList.new(client: client)
      @comment_objects = @comment_list.comment_objects
      Rails.cache.write(user_comments_cache_key(current_user), @comment_objects )
    else
      @comment_objects = sort_repo_comments cached_comment_objects
    end
  end

  private
  def user_comments_cache_key user
    "user_id_#{user.id}_comments"
  end
end
