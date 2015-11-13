class AddGithubIdToComment < ActiveRecord::Migration
  def change
    add_column :comments, :github_id, :integer
  end
end
