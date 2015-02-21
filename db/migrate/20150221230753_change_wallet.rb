class ChangeWallet < ActiveRecord::Migration
  def change
    rename_column :wallets, :stripe_customer_id, :stripe_uid
    add_column :wallets, :stripe_code, :string
    add_column :wallets, :stripe_refresh_token, :string
    add_column :wallets, :stripe_publishable_key, :string
    add_column :wallets, :stripe_scope, :string
    remove_column :wallets, :stripe_token
  end
end
