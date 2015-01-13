class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.integer :review_request_id
      t.integer :user_id
      t.string :aasm_state

      t.timestamps
    end
  end
end
