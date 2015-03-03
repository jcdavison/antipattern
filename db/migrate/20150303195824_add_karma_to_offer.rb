class AddKarmaToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :karma, :boolean, default: nil
  end
end
