class DropPilots < ActiveRecord::Migration
  def up
    drop_table :pilots
  end

  def down
  end
end
