class ChangeAuthorToRepoOwner < ActiveRecord::Migration
  def change
    rename_column :code_reviews, :author, :repo_owner
  end
end
