class ChangePostsColumn < ActiveRecord::Migration
  def up
    change_column :posts, :content, :string, :limit => 1000
  end

  def down
  end
end
