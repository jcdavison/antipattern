class ChangeIsDeletedToDefaultFalse < ActiveRecord::Migration
  def change
    change_column :code_reviews, :is_private, :boolean, default: false
  end
end
