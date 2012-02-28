class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :network_relationship, :first_name, :last_name, :user_id
#  attr_accessor :new_network_name, :new_network_for_who
  has_secure_password
  validates_presence_of :password, :on => :create
  validates :email, :uniqueness => true
  before_create { 
    generate_token(:auth_token) 
  }
  has_many :posts, :class_name => "Post", :finder_sql => Proc.new {
      %Q{
        SELECT DISTINCT *
        FROM posts p
        WHERE p.network_id = #{network_id}
        ORDER BY p.created_at DESC 
      }
  }
  has_many :messages, :class_name => "Message", :finder_sql => Proc.new {
      %Q{
        SELECT MAX(id), * FROM messages WHERE folder_id in 
        (SELECT DISTINCT m.folder_id FROM messages m, recipients r ON m.id = r.message_id
        WHERE r.user_id = 8) GROUP BY folder_id ORDER BY created_at desc;
      }
  }

  belongs_to :network, :class_name => "Network", :foreign_key => "network_id"
  has_many :invitations
  has_one :profile
  
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
  
  def get_members
    @members = User.where("network_id = ?", network_id).order("first_name")
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
