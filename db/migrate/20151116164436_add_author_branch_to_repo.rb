class AddAuthorBranchToRepo < ActiveRecord::Migration
  def change
    add_column :code_reviews, :author, :string
    add_column :code_reviews, :branch, :string
  end
end
