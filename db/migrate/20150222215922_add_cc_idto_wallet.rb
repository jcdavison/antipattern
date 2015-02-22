class AddCcIdtoWallet < ActiveRecord::Migration
  def change
    add_column :wallets, :stripe_cc_id, :string
  end
end
