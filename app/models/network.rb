class Network < ActiveRecord::Base
  attr_accessible :name, :network_for_who, :affiliations_attributes, :users_attributes, :avatar
  validates_presence_of :name
  validates_presence_of :network_for_who

  has_many :affiliations
  has_many :users, through: :affiliations
  has_many :posts
  has_many :invitations
  has_many :events
  accepts_nested_attributes_for :affiliations
  accepts_nested_attributes_for :users

  mount_uploader :avatar, AvatarUploader
end
