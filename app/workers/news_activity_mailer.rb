class NewsActivityMailer
  @queue = :mailer_queue
  def self.perform(post_id)
    UserMailer.news_activity(post_id).deliver
  end
end