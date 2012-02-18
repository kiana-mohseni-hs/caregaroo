class CreateRecepients < ActiveRecord::Migration
  def change
    create_table :recepients do |t|
      t.integer :user_id
      t.integer :message_id
      t.boolean :is_read
      t.boolean :is_deleted

      t.timestamps
    end
  end
end
