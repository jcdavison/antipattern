class AddStripeTokenWallets < ActiveRecord::Migration
  def change
    add_column :wallets, :stripe_access_token, :string
  end
end
