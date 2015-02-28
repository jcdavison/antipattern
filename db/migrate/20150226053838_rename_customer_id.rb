class RenameCustomerId < ActiveRecord::Migration
  def change
    rename_column :wallets, :stripe_cc_id, :stripe_customer_id
  end
end
