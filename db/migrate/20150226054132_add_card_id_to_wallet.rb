class AddCardIdToWallet < ActiveRecord::Migration
  def change
    add_column :wallets, :stripe_card_id, :string
  end
end
