class AddUserTimezone < ActiveRecord::Migration
  def change
  	add_column :users, :time_zone, :string, :limit => 32, :default => 'Pacific Time (US & Canada)'
  end
end
