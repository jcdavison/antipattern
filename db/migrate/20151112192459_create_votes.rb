class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :user_id
      t.integer :voteable_id
      t.string :voteable_type
      t.integer :value

      t.timestamps
    end
  end
end
