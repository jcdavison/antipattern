module QueryHelper
  def all_active_code_reviews
    CodeReview
      .includes(:topics, :user)
      .where(deleted: false)
      .order('created_at DESC')
      .map do |code_review|
        code_review.package_with_associations
      end
  end
end
