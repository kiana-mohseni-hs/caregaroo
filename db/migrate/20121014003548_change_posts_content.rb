class ChangePostsContent < ActiveRecord::Migration
  def up
    change_column :posts, :content, :text
    change_column :comments, :content, :text
  end

  def down
  end
end
