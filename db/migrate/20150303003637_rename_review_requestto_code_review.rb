class RenameReviewRequesttoCodeReview < ActiveRecord::Migration
  def change
    rename_table :review_requests, :code_reviews
  end
end
