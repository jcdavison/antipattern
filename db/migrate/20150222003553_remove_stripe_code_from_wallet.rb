class RemoveStripeCodeFromWallet < ActiveRecord::Migration
  def change
    remove_columns :wallets, :stripe_code
  end
end
