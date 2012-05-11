class NewsActivityMailer
  @queue = :mailer_queue
  def self.perform(post_id)
    post = Post.find(post_id)
    network = Network.find(post.network_id)
    members = User.joins(:notification).where("users.network_id = ?", post.network_id)
    # emails = members.collect(&:email).join(";")
    members.each do |m|
      UserMailer.news_activity(post, m, network.network_for_who).deliver
    end
  end
end