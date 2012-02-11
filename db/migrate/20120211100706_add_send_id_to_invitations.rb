class AddSendIdToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :send_id, :integer
  end
end
