class AddDeleteToReviewRequest < ActiveRecord::Migration
  def change
    add_column :review_requests, :deleted, :boolean, default: false 
  end
end
