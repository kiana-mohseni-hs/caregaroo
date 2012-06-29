class Event < ActiveRecord::Base
  has_event_calendar
  belongs_to :network
  
  attr_accessible :name, :start_at, :end_at, :network_id
  
end
