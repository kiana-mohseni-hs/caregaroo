class Event < ActiveRecord::Base
  has_event_calendar
  belongs_to :network
  belongs_to :event_type
  has_and_belongs_to_many :users
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updater, :class_name => "User", :foreign_key => "updated_by_id"
  belongs_to :canceler, :class_name => "User", :foreign_key => "canceled_by_id"
  belongs_to :post
  has_many :comments, through: :post
  
  validates_presence_of :name
  validates_datetime :start_at, :on_or_before => :end_at,
                                :on_or_before_message => 'date/time cannot be later than End at date/time',
                                :on_or_after => :now,
                                :on_or_after_message => 'date/time cannot be in the past'
  validates_datetime :end_at,   :on_or_after => :now,
                                :on_or_after_message => 'date/time cannot be in the past'
  validates :description, length: { :maximum => 1275 }
  
  after_create :post_new_event
  after_update :update_post
    
  attr_accessible :name,
                  :start_at,
                  :end_at,
                  :network_id,
                  :event_type_id,
                  :location,
                  :description,
                  :post_id,
                  :user_ids,
                  :created_by_id,
                  :updated_by_id,
                  :canceled_by_id,
                  :canceled
  
  scope :visible, where(canceled: false)
  scope :future, where(['start_at >= ?', Time.now.beginning_of_day])
  
  scope :start_before_date, lambda { |date|  where(['start_at <= ?', date.beginning_of_day])  }
  scope :end_after_date, lambda { |date|  where(['end_at > ?', date.beginning_of_day])  }
  
  def is_new?
    self.updated_at === self.created_at
  end
  
  def is_one_day?
    self.start_at.to_date === self.end_at.to_date
  end
  
  def is_on?(date)
    (self.start_at.to_date..self.end_at.to_date).cover?(date)
  end
  
  def begins_on?(date)
    self.start_at.to_date === date
  end
  
  def ends_on?(date)
    self.end_at.to_date === date
  end
  
  def cancel(canceler_id)
    self.canceled_by_id = canceler_id
    self.canceled = true
    self.save(validate: false)
  end
  
  def datestring
    start_at.strftime("%a %e %b %Y")
  end

  def timestring
    start_at.strftime("%l:%M %p - ") << end_at.strftime("%l:%M %p")
  end

  def datetimestring
    is_one_day? ? datestring << " " << timestring : multidaydatetimestring
  end
  
  def multidaydatetimestring
    datestring << " " << start_at.strftime("%l:%M %p to ") << end_at.strftime("%a %e %b %Y") << " " << end_at.strftime("%l:%M %p")
  end
  
  def locationstring
    location.blank? ? "" : "<br/>#{location}"
  end
  
  def post_new_event
    create_post(
      name: name, 
      content: name,
      user_id: created_by_id, 
      network_id: network_id 
      )
    update_column("post_id", post.id)
  end
        
  def update_post
    post.update_attributes(
      name: name, 
      content: name
      ) unless post.nil?
  end
  
end
