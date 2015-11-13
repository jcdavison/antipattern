class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :code_review_id
      t.string :body

      t.timestamps
    end
  end
end
