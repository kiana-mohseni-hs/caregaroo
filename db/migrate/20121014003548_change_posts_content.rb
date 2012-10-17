class ChangePostsContent < ActiveRecord::Migration
  def up
    change_column :posts, :content, :text, :limit => 3000
    change_column :comments, :content, :text, :limit => 3000
  end

  def down
  end
end
