class AddStripeTokenWallets < ActiveRecord::Migration
  def change
    add_column :wallets, :stripe_token, :string
  end
end
