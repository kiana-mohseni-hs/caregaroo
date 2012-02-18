class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :bio
      t.string :location
      t.string :significant_other
      t.string :kids_name
      t.date :birthdate
      t.string :expertise
      t.string :can_help_with
      t.string :phone_work
      t.string :phone_mobile
      t.integer :user_id

      t.timestamps
    end
  end
end
