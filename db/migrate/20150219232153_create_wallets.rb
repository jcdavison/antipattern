class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.string :stripe_token
      t.string :stripe_customer_id
      t.integer :user_id

      t.timestamps
    end
  end
end
