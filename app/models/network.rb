class Network < ActiveRecord::Base
  attr_accessible :network_name, :network_for_who
  has_many :users
  has_many :posts
end
