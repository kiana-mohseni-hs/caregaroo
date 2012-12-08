class CreateLandpageData < ActiveRecord::Migration
  def change
    create_table :landpage_data do |t|
      t.string :email
      t.string :campaign
      t.timestamps
    end
  end
end
