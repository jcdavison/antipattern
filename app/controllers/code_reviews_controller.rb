include OctoHelper
include ObjHelper
include StructuralHelper

class CodeReviewsController < ApplicationController

  def show
    @code_review = CodeReview.preload(:user).find params[:id]
    @code_review_owner = @code_review.user.to_waffle.attributes!
    commit_blob = build_commit_blob(OCTOCLIENT.get(commit_url(@code_review))) 
    comments = grab_comments(@code_review, OCTOCLIENT).map {|e| e.to_attrs }
    @comments = change_key(comments, :id, :github_id)
    save_and_associate({find_key: :github_id, objects: @comments, attributes: [:body, :github_id], class: 'Comment', parent: @code_review})
    @commit_blob = inject_comments_into @comments, commit_blob
    @commit_blob[:info].merge!({repo: @code_review.repo, commitSha: @code_review.commit_sha})
    # rescue 
    #   redirect_to authenticated_root_path
  end
end
