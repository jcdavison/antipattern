class RenameColumnsPayment < ActiveRecord::Migration
  def change
    rename_column :payments, :from_id, :from_user_id
    rename_column :payments, :to_id, :to_user_id
  end
end
