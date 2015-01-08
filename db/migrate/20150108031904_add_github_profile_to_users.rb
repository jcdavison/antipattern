class AddGithubProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :github_profile, :string
  end
end
