module DailyActivityEmails
  @queue = :daily_activity_emails_queue
  
  def self.perform()
    networks = Network.all
    now = Date.today
    if Rails.env.production?
      end_time = DateTime.new(now.year, now.month, now.day, 24, 0, 0, 0) # utc time
      start_time = end_time.advance(:hours => -24)
    else
      end_time = DateTime.current
      start_time = end_time.advance(:minutes => -10)      
    end
    
    networks.each do |n|
      posts = Post.where(:network_id => n.id, :created_at => start_time..end_time).select {|p| p.content.present?}      
      if posts.length > 0
        user_list = {}
        members = User.joins(:notification).where("users.network_id = ? and notifications.post_update = ?", n.id, true)
        
        members.each do |m|
          user_list[m.email] = {:first_name => m.first_name, :last_name => m.last_name}
        end
        
        invitations = Invitation.where(:network_id => n.id)
        invitations.each do |m|
            user_list[m.email] = {:first_name => m.first_name, :last_name => m.last_name, :token => m.token}
        end

        user_list.each do |email, u|
          UserMailer.daily_news_activity(posts, email, u[:first_name], u[:last_name], n.network_for_who, u[:token]).deliver
        end
        
      end
    end
  end
end
