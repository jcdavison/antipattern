class RemoveValueFromCodeReview < ActiveRecord::Migration
  def change
    remove_column :code_reviews, :value
  end
end
