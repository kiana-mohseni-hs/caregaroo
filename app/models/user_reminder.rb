class UserReminder < ActiveRecord::Base
  attr_accessible :event_id, :moment, :user_id, :delivery_type
  belongs_to :user
  belongs_to :event


  def self.create_user_reminders(user, event)
  	user.user_reminder_settings.each do |setting|
  		UserReminder.create user_id: user.id, event_id: event.id, delivery_type: setting.delivery_type, moment: setting.moment(event)
  	end
  end

  def self.send_reminders
  	startMoment = Time.now
  	startMoment = startMoment - startMoment.sec
  	startMoment = startMoment - startMoment.subsec
  	finishMoment = startMoment + 9.minutes
 	puts UserReminder.find_all_by_moment(startMoment..finishMoment)
  	UserReminder.find_all_by_moment(startMoment..finishMoment).each do |user_remainder|
  		user_remainder.send("send_#{user_remainder.delivery_type}")
  	end
  end

  def send_email()
  	puts "sending email: #{@user.id} - #{@event.id}"
  	Resque.enqueue(UserReminderMailer, @user.id, @event.id)
  end

  def send_sms()
  	sms = "Caregaroo Reminder: #{event.name}(#{event.creator}) starts #{event.start_at}
  	logger.debug "sending sms: #{sms}"
  end

end
