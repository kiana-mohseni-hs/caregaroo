class Event < ActiveRecord::Base
  has_event_calendar
  belongs_to :network
  belongs_to :event_type
  has_and_belongs_to_many :users
  
  attr_accessible :name, :start_at, :end_at, :network_id, :event_type_id, :location, :description
  
end
