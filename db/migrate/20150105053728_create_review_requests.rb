class CreateReviewRequests < ActiveRecord::Migration
  def change
    create_table :review_requests do |t|
      t.integer :value
      t.text :detail
      t.integer :user_id

      t.timestamps
    end
  end
end
