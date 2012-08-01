class AddCanceledByIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :canceled_by_id, :integer

  end
end
