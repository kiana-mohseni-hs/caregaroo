class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.boolean :announcement
      t.boolean :post_update
      t.boolean :response_post
      t.boolean :calendar_task_added
      t.boolean :member_volunteer_task
      t.boolean :receive_thanks
      t.boolean :member_receives_thanks
      t.integer :user_id

      t.timestamps
    end
  end
end
