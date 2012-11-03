class Post < ActiveRecord::Base
  attr_accessible :name, :content, :network_id, :user_id, :photo
  has_many :comments, dependent: :destroy, order: "updated_at DESC"
  belongs_to :user
  has_one :event
  has_many :post_recipients, :dependent => :destroy
  has_many :recipients, :through => :post_recipients, :source => :user
  default_scope order("created_at desc")

  mount_uploader :photo, NewsUploader
  
  def not_an_event?
    self.event.nil?
  end
  
  def is_event?
    self.event.present?
  end

  def self.visible_to user
    joins(:post_recipients).where("post_recipients.user_id = 0 OR post_recipients.user_id = #{user.id}")
  end

  def self.open_
    joins(:post_recipients).where("post_recipients.user_id = 0")
  end
  
end
