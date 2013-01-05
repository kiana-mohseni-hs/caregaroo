class CreateUserReminders < ActiveRecord::Migration
  def change
    create_table :user_reminders do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :delivery_type
      t.datetime :moment      

      t.timestamps
    end
    add_index :user_reminders, :user_id
    add_index :user_reminders, :event_id
    add_index :user_reminders, :moment
  end
end
