class AddDeletedToCommentFeed < ActiveRecord::Migration
  def change
    add_column :comment_feeds, :deleted, :boolean, default: false
  end
end
