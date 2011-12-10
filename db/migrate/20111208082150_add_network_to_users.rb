class AddNetworkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :network_name, :string
    add_column :users, :network_for_who, :string
    add_column :users, :network_relationship, :string
  end
end
