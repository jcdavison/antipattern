class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :offer_id
      t.integer :from_id
      t.integer :to_id
      t.string :description
      t.integer :value

      t.timestamps
    end
  end
end
