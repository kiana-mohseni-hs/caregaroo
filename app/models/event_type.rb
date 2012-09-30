class EventType < ActiveRecord::Base
  has_many :events

  attr_accessible :name

  ALL = %w(Appointment Ride Meal Visit Other)
  
end
