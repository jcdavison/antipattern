class AddCommitShatoCodeReview < ActiveRecord::Migration
  def change
    add_column :code_reviews, :commit_sha, :string
  end
end
