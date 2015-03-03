class AddValueToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :value, :integer
  end
end
