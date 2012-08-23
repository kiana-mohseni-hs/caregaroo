class AddNetworkIdToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :network_id, :integer

  end
end
