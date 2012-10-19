class CreateInnitialPublicPostRecipients < ActiveRecord::Migration
  def up
  	Post.all.each do |p| 
  		p.post_recipients.create!({user_id: 0}) if p.post_recipients.size == 0
  	end
  end

  def down
  end
end
