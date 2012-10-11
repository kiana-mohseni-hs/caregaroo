class Affiliation < ActiveRecord::Base
  belongs_to :network
  belongs_to :user
  attr_accessible :relationship, :role, :network_id, :user_id
end
