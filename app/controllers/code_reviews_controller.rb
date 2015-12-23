include OctoHelper
include ObjHelper
include StructuralHelper

class CodeReviewsController < ApplicationController

  def index
    if current_user
      private_code_reviews = all_accessible_private_code_reviews current_user.github_username
      @code_reviews = [ all_active_public_code_reviews, private_code_reviews ].flatten.sort_by {|c| c["createdAt"] }.reverse
    else
      @code_reviews = all_active_public_code_reviews
    end
  end

  def show
    @code_review = CodeReview.preload(:user).find params[:id]
    enforce_private_repo_access if @code_review.is_private
    @code_review_owner = @code_review.user.to_waffle.attributes!
    commit_blob = build_commit_blob(OCTOCLIENT.get(commit_url(@code_review))) 
    github_comment_colletion = grab_comments(@code_review, OCTOCLIENT).map {|e| e.to_attrs }
    comments_by_github_id = change_key(github_comment_colletion, :id, :github_id)
    comments = save_and_associate({find_key: :github_id, objects: comments_by_github_id, attributes: [:body, :github_id], class: 'Comment', parent: @code_review})
    @commit_blob = inject_comments_into comments[:input_objs], commit_blob
    @commit_blob[:info].merge!({repo: @code_review.repo, commitSha: @code_review.commit_sha, context: @code_review.context})
    rescue 
      redirect_to code_reviews_path
  end
end
