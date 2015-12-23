module QueryHelper
  INCLUDES = [:topics, :user]
  def all_active_public_code_reviews
    CodeReview.includes(INCLUDES).all_active.all_public
      .map { |code_review| code_review.package_with_associations }
  end

  def all_accessible_private_code_reviews username
    CodeReview.includes(INCLUDES).all_active.all_private
      .select { |code_review| user_has_access? code_review.collaborators, username }
      .map { |code_review| code_review.package_with_associations }
  end

  private 
    def user_has_access? collaborators, username
      collaborators.include? username
    end
end
