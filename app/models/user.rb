class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :network_name, :network_for_who, :network_relationship, :first_name, :last_name
  has_secure_password
  validates_presence_of :password, :on => :create
  validates :email, :uniqueness => true
  before_create { generate_token(:auth_token) }
  has_many :news

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.hex
    end while User.exists?(column => self[column])
  end
  
  attr_writer :current_step
  
  def current_step
    @current_step || steps.first  
  end
  
  def steps
    %w[network profile]
  end
  
  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end
  
  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end
  
  def first_step?
    current_step == steps.first
  end
  
  def last_step?
    current_step == steps.last
  end
  
end
