class PopulateAffiliations < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.affiliations.create(network_id: user.network_id, relationship: user.network_relationship, role: user.role)
    end
    remove_column :users, :network_relationship
    remove_column :users, :role
  end

  def down
    add_column :users, :network_relationship, :string
    add_column :users, :role, :string
    User.all.each do |user|
      a = user.affiliations.first
      user.network_relationship = a.relationship
      user.role = a.role
      user.save!
    end
    Affiliation.destroy_all
  end
end



