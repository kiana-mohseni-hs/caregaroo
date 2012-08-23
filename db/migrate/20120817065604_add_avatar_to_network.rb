class AddAvatarToNetwork < ActiveRecord::Migration
  def change
    add_column :networks, :avatar, :string

  end
end
