class CreatePilotSignups < ActiveRecord::Migration
  def change
    create_table :pilot_signups do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :signup_type

      t.timestamps
    end
  end
end
