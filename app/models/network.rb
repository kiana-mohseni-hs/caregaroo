class Network < ActiveRecord::Base
  attr_accessible :network_name, :network_for_who, :users_attributes
  validates_presence_of :network_name
  validates_presence_of :network_for_who
  
  has_many :users
  has_many :posts
  accepts_nested_attributes_for :users
  
  
  #, :reject_if => proc { |attributes| attributes['name'].blank? }
  #, :reject_if => :all_blank
end
