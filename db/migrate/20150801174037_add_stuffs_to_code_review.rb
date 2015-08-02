class AddStuffsToCodeReview < ActiveRecord::Migration
  def change
    rename_column :code_reviews, :detail, :context
    add_column :code_reviews, :url, :string
  end
end
