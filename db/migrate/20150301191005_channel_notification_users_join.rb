class ChannelNotificationUsersJoin < ActiveRecord::Migration
  def change
    create_table :notification_channels_users do |t|
      t.integer :notification_channel_id
      t.integer :user_id
    end
    
  end
end
