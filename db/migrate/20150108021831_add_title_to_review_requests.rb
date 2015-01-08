class AddTitleToReviewRequests < ActiveRecord::Migration
  def change
    add_column :review_requests, :title, :string
  end
end
