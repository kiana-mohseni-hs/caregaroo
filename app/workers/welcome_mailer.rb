class WelcomeMailer
  @queue = :mailer_queue
  def self.perform(user_id)
    UserMailer.welcome_initator(user_id).deliver
  end
end