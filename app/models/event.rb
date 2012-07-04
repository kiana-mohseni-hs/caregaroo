class Event < ActiveRecord::Base
  has_event_calendar
  belongs_to :network
  belongs_to :event_type
  has_and_belongs_to_many :users
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updater, :class_name => "User", :foreign_key => "updated_by_id"
  
  validates_presence_of :start_at
  validates_presence_of :end_at
  validates_presence_of :name
    
  attr_accessible :name,
                  :start_at,
                  :end_at,
                  :network_id,
                  :event_type_id,
                  :location,
                  :description,
                  :user_ids,
                  :created_by_id,
                  :updated_by_id
    
end
