class RenameColumns < ActiveRecord::Migration
  def change
    rename_column :offers, :review_request_id, :code_review_id
  end
end
