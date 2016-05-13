class AddGithubIdentityToCommentFeed < ActiveRecord::Migration
  def change
    add_column :comment_feeds, :github_entity, :string
  end
end
