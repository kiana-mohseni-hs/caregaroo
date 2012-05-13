class CommentsActivityMailer
  @queue = :mailer_queue
  def self.perform(comment_id)
    comment = Comment.find(comment_id)
    post = Post.find(comment.post_id)
    network = Network.find(post.network_id)
    members = User.joins(:notification).where("users.network_id = ? and notifications.post_update = ? and users.id <> ?", post.network_id, true, comment.user_id)
    members.each do |m|
      UserMailer.comments_activity(post, comment, m.email, network.network_for_who).deliver
    end
  end
end