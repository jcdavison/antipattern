class CreateCommentFeeds < ActiveRecord::Migration
  def change
    create_table :comment_feeds do |t|
      t.string :repository
      t.integer :user_id
      t.string :url_slug

      t.timestamps
    end
  end
end
