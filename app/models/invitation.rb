class Invitation < ActiveRecord::Base
  
  attr_accessible :email, :first_name, :last_name, :generate_token
  
  validates_presence_of :email
  #validates_uniquness_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  
  # has_one :network, :through => :user
  
  before_create :generate_token
  
  def generate_token
    #self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
    #self.token = SecureRandom.hex
    self.token = SecureRandom.base64.tr("+/", "-_")
    #urlsafe_base64
  end
  
end
