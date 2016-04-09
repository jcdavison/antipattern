class CommentsSentimentsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :comments, :sentiments
  end
end
