class CreatePostRecipients < ActiveRecord::Migration
  def change
    create_table :post_recipients do |t|
      t.integer :user_id
      t.integer :post_id
      t.timestamps
    end
  end
end
