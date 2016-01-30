class AddPrivateScopeToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :private_scope, :boolean, default: false
  end
end
