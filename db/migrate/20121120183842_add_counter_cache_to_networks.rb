class AddCounterCacheToNetworks < ActiveRecord::Migration
  def self.up
    add_column :networks, :users_count, :integer, null: false, default: 0
    add_column :networks, :posts_count, :integer, null: false, default: 0
    add_column :networks, :events_count, :integer, null: false, default: 0
    
    Network.reset_column_information

    Network.all.each do |n|
    	Network.update_counters n.id, :users_count  => n.users.length, :posts_count  => n.posts.length, :events_count => n.events.length
    end
  end

  def self.down
    remove_column :networks, :users_count
    remove_column :networks, :posts_count
    remove_column :networks, :events_count
  end
end
