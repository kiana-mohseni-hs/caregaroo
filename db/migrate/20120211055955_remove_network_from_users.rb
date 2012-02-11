class RemoveNetworkFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :network_for_who
    remove_column :users, :network_name
  end

  def down
    add_column :users, :network_name, :string
    add_column :users, :network_for_who, :string
  end
end
