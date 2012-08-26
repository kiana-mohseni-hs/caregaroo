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
  
  validates_presence_of :start_at
  validates_presence_of :end_at
  validates_presence_of :name
  
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
  
  def cancel(canceler_id)
    update_attributes(canceled_by_id: canceler_id, canceled: true)
  end
  
  def datestring
    start_at.strftime("%a, %e %b %Y")
  end

  def timestring
    start_at.strftime("%l:%M%P - ") << end_at.strftime("%l:%M%P")
  end

  def datetimestring
    datestring << ", " << timestring
  end
  
  def locationstring
    location.blank? ? "" : "<br/>#{location}"
  end
  
  def post_new_event
    create_post(
      name: "New Event: #{name}", 
      content: "New Event: #{name} (#{event_type.name})<br/>" << 
               datetimestring <<
               locationstring,
      user_id: created_by_id, 
      network_id: network_id 
      )
    update_column("post_id", post.id)
  end
    
  def update_post
    change = canceled ? "Canceled" : "Updated"
    eventtype = event_type.nil? ? "" : event_type.name
    new_content = "#{change} Event: #{name} (#{eventtype})<br/> " << 
                  datetimestring <<
                  locationstring
    if canceled
      new_content << "<br/>canceled by #{canceler.first_name}"
    else
      new_content << "<br/>updated by #{updater.first_name}" unless updater == creator
    end
    post.update_attributes(
      name: "#{change} Event: #{name}", 
      content: new_content
      ) unless post.nil?
  end
end
