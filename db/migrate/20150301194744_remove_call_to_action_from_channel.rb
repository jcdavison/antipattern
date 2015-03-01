class RemoveCallToActionFromChannel < ActiveRecord::Migration
  def change
    remove_column :notification_channels, :call_to_action
  end
end
