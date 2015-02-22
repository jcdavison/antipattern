class AddStripeCcTokenToWallet < ActiveRecord::Migration
  def change
    add_column :wallets, :stripe_cc_token, :string
  end
end
