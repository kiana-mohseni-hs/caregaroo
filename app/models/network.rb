class Network < ActiveRecord::Base
  attr_accessible :network_name, :network_for_who, :users_attributes
  has_many :users
  has_many :posts
  accepts_nested_attributes_for :users
  #, :reject_if => proc { |attributes| attributes['name'].blank? }
  #, :reject_if => :all_blank
end
