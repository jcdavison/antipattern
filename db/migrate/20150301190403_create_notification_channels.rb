class CreateNotificationChannels < ActiveRecord::Migration
  def change
    create_table :notification_channels do |t|
      t.string :name
      t.string :call_to_action

      t.timestamps
    end
  end
end
