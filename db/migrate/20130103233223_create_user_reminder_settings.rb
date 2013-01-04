class CreateUserReminderSettings < ActiveRecord::Migration
  def change
    create_table :user_reminder_settings do |t|
      t.integer :user_id
      t.string :delivery_type
      t.integer :time_before
      t.string :time_unit

      t.timestamps
    end
    add_index :user_reminder_settings, :user_id
  end
end
