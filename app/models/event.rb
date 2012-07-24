class Event < ActiveRecord::Base
  has_event_calendar
  belongs_to :network
  belongs_to :event_type
  has_and_belongs_to_many :users
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by_id"
  belongs_to :updater, :class_name => "User", :foreign_key => "updated_by_id"
  belongs_to :post
  
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
                  :canceled
  
  scope :visible, where(canceled: false)
  
  def cancel
    update_attributes(canceled: true)
  end
  
  def datetimestring
    start_at.strftime("%a, %e %b %Y, %l:%M%P - ") << end_at.strftime("%l:%M%P")
  end
  
  def post_new_event
    create_post(
      name: "New Event: #{name}", 
      content: "New Event: #{name} (#{event_type.name})<br/>" << 
               datetimestring <<
               "<br/>#{location}", 
      user_id: created_by_id, 
      network_id: network_id 
      )
    update_column("post_id", post.id)
  end
    
  def update_post
    change = canceled ? "Canceled" : "Updated"
    new_content = "#{change} Event: #{name} (#{event_type.name})<br/> " << 
                  datetimestring <<
                  "<br/>#{location}"
    new_content << "<br/>updated by #{updater.first_name}" unless updater == creator
    post.update_attributes(
      name: "#{change} Event: #{name}", 
      content: new_content
      ) unless post.nil?
  end
end
