class Post < ActiveRecord::Base
  attr_accessible :name, :content, :network_id, :user_id
  has_many :comments, dependent: :destroy, order: "updated_at DESC"
  belongs_to :user
  has_one :event
  has_many :post_recipients, :dependent => :destroy
  has_many :recipients, :through => :post_recipients, :source => :user
  default_scope order("created_at desc")
  
  def not_an_event?
    self.event.nil?
  end
  
  def is_event?
    self.event.present?
  end
  
end
