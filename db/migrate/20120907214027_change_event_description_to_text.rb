class ChangeEventDescriptionToText < ActiveRecord::Migration
  def up
      change_column :events, :description, :text
  end
  def down
      # This might cause trouble if you have strings longer
      # than 255 characters.
      change_column :events, :description, :string
  end
end


