class CreateAffiliations < ActiveRecord::Migration
  def change
    create_table :affiliations do |t|
      t.string :relationship
      t.references :network
      t.references :user

      t.timestamps
    end
    add_index :affiliations, :network_id
    add_index :affiliations, :user_id
  end
end
