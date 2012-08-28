class AddDefaultValueToEventTypeId < ActiveRecord::Migration
  def up
      change_column :events, :event_type_id, :integer, :default => 1
  end

  def down
      change_column :events, :event_type_id, :integer, :default => nil
  end
end
