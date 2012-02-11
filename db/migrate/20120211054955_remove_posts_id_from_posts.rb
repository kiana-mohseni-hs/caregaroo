class RemovePostsIdFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :user_id
  end

  def down
    add_column :posts, :user_id, :integer
  end
end
