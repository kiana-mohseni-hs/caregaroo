class Invitation < ActiveRecord::Base
  
  attr_accessible :email, :first_name, :last_name, :generate_token, :network_id
  
  validates :email, :presence => true, :email_format => true 
  validates_presence_of :first_name
  validates_presence_of :last_name
  
  belongs_to :network
  
  before_create :generate_token
  
  def generate_token
    self.token = SecureRandom.base64.tr("+/", "-_")
  end
  
end
