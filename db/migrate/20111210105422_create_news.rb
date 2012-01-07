class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :name
      t.string :content
      t.integer :user_id

      t.timestamps
    end
  end
end
