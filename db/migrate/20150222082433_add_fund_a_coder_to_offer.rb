class AddFundACoderToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :fund_a_coder, :integer
  end
end
