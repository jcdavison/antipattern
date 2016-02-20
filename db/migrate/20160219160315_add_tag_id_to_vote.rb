class AddTagIdToVote < ActiveRecord::Migration
  def change
    add_column :votes, :sentiment_id, :integer
  end
end
