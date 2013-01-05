class UserReminder < ActiveRecord::Base
  attr_accessible :event_id, :moment, :user_id, :delivery_type
  belongs_to :user
  belongs_to :event


  def self.create_user_reminders(user, event)
  	user.user_reminder_settings.each do |setting|
  		UserReminder.create user_id: user.id, event_id: event.id, delivery_type: setting.delivery_type, moment: setting.moment(event)
  	end
  end


end
