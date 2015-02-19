class RemoveVenmopmts < ActiveRecord::Migration
  def change
    drop_table :venmo_pmts
  end
end
