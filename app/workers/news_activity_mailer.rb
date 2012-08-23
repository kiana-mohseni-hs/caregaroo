class NewsActivityMailer
  @queue = :mailer_queue
  def self.perform(post_id)
    post = Post.find(post_id)
    network = Network.find(post.network_id)
    members = User.joins(:notification).where("users.network_id = ? and notifications.post_update = ?", post.network_id, true)
    # emails = members.collect(&:email).join(";")
    user_list = {}
    members.each do |m|
      # UserMailer.news_activity(post, m, network.network_for_who).deliver
      user_list[m.email] = {:first_name => m.first_name, :last_name => m.last_name}
    end
    invitations = Invitation.where("network_id = ?", post.network_id)
    invitations.each do |m|
        user_list[m.email] = {:first_name => m.first_name, :last_name => m.last_name}
    end
    user_list.each do |email, u|
      UserMailer.news_activity(post, email, u[:first_name], u[:last_name], network.network_for_who).deliver
      # UserMailer.news_activity(post, email, 'Snoopy', 'Charlie', network.network_for_who).deliver
    end
  end
end