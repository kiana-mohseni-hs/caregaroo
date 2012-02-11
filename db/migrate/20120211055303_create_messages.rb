class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body
      t.integer :sender_id
      t.integer :parent_id

      t.timestamps
    end
  end
end
