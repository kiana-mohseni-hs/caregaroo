class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :parent_id
      t.integer :sender_id
      t.string :body
      t.integer :recepient_id

      t.timestamps
    end
  end
end
