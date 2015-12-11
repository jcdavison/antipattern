class AddIsPrivateToCodeReview < ActiveRecord::Migration
  def change
    add_column :code_reviews, :is_private, :boolean
  end
end
