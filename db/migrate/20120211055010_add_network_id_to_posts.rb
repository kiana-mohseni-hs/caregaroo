class AddNetworkIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :network_id, :integer
  end
end
