class AddRepoToCodeReview < ActiveRecord::Migration
  def change
    add_column :code_reviews, :repo, :string
  end
end
