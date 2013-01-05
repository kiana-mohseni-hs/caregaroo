class UserReminderMailer
  @queue = :mailer_queue
  def self.perform(user_id, event_id)
    UserMailer.reminder(user_id, event_id).deliver
  end
end