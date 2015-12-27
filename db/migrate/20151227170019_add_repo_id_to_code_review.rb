class AddRepoIdToCodeReview < ActiveRecord::Migration
  def change
    add_column :code_reviews, :repo_id, :integer
  end
end
