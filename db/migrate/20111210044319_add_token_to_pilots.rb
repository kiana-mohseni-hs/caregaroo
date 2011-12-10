class AddTokenToPilots < ActiveRecord::Migration
  def change
    add_column :pilots, :token, :string
    add_column :pilots, :sent_at, :datetime
  end
end
