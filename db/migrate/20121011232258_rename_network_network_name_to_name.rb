class RenameNetworkNetworkNameToName < ActiveRecord::Migration
  def up
    rename_column :networks, :network_name, :name
  end

  def down
    rename_column :networks, :name, :network_name
  end
end
