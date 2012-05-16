class AddPhoneHomeToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :phone_home, :string
    add_column :profiles, :phone_work_ext, :string
  end
end
