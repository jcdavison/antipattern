class ChangeVotesUserIdColumnType < ActiveRecord::Migration
  def change
    change_column :votes, :user_id, 'integer USING CAST(user_id AS integer)'
  end
end
