class AddPostIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :post_id, :integer

  end
end
