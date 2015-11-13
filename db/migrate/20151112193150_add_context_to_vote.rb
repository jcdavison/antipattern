class AddContextToVote < ActiveRecord::Migration
  def change
    add_column :votes, :context, :string
  end
end
