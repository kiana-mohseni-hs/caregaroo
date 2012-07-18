class AddCreatorAndUpdaterToEvent < ActiveRecord::Migration
  def change
    add_column :events, :created_by_id, :integer

    add_column :events, :updated_by_id, :integer

  end
end
