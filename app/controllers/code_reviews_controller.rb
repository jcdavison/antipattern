include OctoHelper
include QueryHelper
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
    @reviewable_commit = ReviewableCommit.new(@code_review)
    rescue 
      redirect_to code_reviews_path
  end
end
