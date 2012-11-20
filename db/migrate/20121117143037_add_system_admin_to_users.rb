class AddSystemAdminToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :system_admin, :boolean, {:null => false, :default => false}

    User.reset_column_information
  	
    User.create!(
  		{
	  		:email        => 'admin@caregaroo.com', 
	  		:password     => 'cgadmpass', 
	  		:first_name   => 'Caregaroo', 
	  		:last_name    => 'Admin',
	  		:system_admin => true
	  	},
  		:without_protection => true
  	)

  end

  def down
  	remove_column :users, :system_admin
  end
end
