class RemoveNewsIdFromComments < ActiveRecord::Migration
  def up
    remove_column :comments, :news_id
  end

  def down
    add_column :comments, :news_id, :integer
  end
end
