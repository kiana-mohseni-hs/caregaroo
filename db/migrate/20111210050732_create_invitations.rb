class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :token
      t.datetime :sent_at

      t.timestamps
    end
  end
end
