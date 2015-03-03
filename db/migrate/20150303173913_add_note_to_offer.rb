class AddNoteToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :note, :string
  end
end
