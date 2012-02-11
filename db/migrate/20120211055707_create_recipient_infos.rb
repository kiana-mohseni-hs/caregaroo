class CreateRecipientInfos < ActiveRecord::Migration
  def change
    create_table :recipient_infos do |t|
      t.boolean :isUnread
      t.boolean :isDeleted
      t.integer :message_id

      t.timestamps
    end
  end
end
