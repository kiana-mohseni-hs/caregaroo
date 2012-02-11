class CreateNetworks < ActiveRecord::Migration
  def change
    create_table :networks do |t|
      t.string :network_name
      t.string :network_for_who
      t.integer :host_user_id

      t.timestamps
    end
  end
end
