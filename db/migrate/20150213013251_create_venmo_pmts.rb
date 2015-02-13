class CreateVenmoPmts < ActiveRecord::Migration
  def change
    create_table :venmo_pmts do |t|
      t.string :provider
      t.string :uid
      t.string :token
      t.string :refresh_token
      t.integer :expires_at
      t.string :username
      t.string :profile
      t.string :display_name
      t.integer :user_id

      t.timestamps
    end
  end
end
