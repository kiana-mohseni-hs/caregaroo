class Network < ActiveRecord::Base
  attr_accessible :network_name, :network_for_who, :users_attributes, :avatar
  validates_presence_of :network_name
  validates_presence_of :network_for_who
  
  has_many :users
  has_many :posts
  has_many :events
  accepts_nested_attributes_for :users
  mount_uploader :avatar, AvatarUploader
  
  #, :reject_if => proc { |attributes| attributes['name'].blank? }
  #, :reject_if => :all_blank
end
