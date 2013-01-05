class UserReminderSetting < ActiveRecord::Base
  attr_accessible :time_before, :time_unit, :delivery_type
  belongs_to :user

  validates :time_before, :numericality => true
  validates :time_unit, :inclusion => { in: %w(minute hour day)}
  validates :delivery_type, :inclusion => { in: %w(sms email)}

  def moment(event)
  	event.start_at - time_before.send(time_unit.to_sym)
  end

end
