class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, 
                  :network_id, :avatar, :notification_attributes, :profile_attributes, :time_zone
  has_secure_password
  validates :email, :presence => true, :email_format => true, :uniqueness => true
  validates_presence_of :password, :on => :create
  validates_length_of :password, :minimum => 6, :on => :create

  validates_presence_of :first_name
  validates_presence_of :last_name
  
  has_many :affiliations
  has_many :networks, through: :affiliations
  belongs_to :network, :counter_cache => true
  has_many :invitations
  has_many :post_recipients
  has_many :recipients
  has_many :messages, through: :recipients
  has_one  :profile
  has_one  :notification
  has_many :posts, uniq: true, order: 'created_at DESC'
  has_many :latest_messages, :class_name => "Message", :finder_sql => Proc.new {
      %Q{
        SELECT MAX(id), * FROM messages WHERE folder_id in 
        (SELECT DISTINCT m.folder_id FROM messages m, recipients r ON m.id = r.message_id
        WHERE r.user_id = #{id}) GROUP BY folder_id ORDER BY created_at desc;
      }
  }
  has_many :comments
  has_and_belongs_to_many :events
  
  accepts_nested_attributes_for :notification, :allow_destroy => true
  accepts_nested_attributes_for :profile, :allow_destroy => true
  mount_uploader :avatar, AvatarUploader
  
  before_create { 
    generate_token(:auth_token) 
  }
  
  def get_related_messages(folder_id)
      @messages = Message.where("folder_id = ?", folder_id).order("created_at")
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.base64.tr("+/", "-_")
    end while User.exists?(column => self[column])
  end
  
  def get_members
    User.where("network_id = ?", network_id).order("first_name")
  end
  
  ROLES = {
    "admin" => "Admin",
    "initiator" => "Initiator",
    "coordinator" => "Coordinator" 
  }
  def is_admin?(for_network_id = network_id)
    self.role(for_network_id) == ROLES["admin"]
  end
  def is_initiator?(for_network_id = network_id)
    self.role(for_network_id) == ROLES["initiator"]
  end
  def is_coordinator?(for_network_id = network_id)
    self.role(for_network_id) == ROLES["coordinator"]
  end
  def is_initiator_or_coordinator?(for_network_id = network_id)
    self.role(for_network_id) == ROLES["initiator"] || self.role(for_network_id) == ROLES["coordinator"]
  end
  
  def is_system_admin?
    self.system_admin
  end
  
  def name
    (first_name || "") + ' ' + (last_name || "")
  end
  
  def affiliation(for_network_id = network_id)
    affiliations.find_by_network_id(for_network_id)
  end
  
  def role(for_network_id = network_id)
    affiliation(for_network_id).role 
  end

  def network_relationship(for_network_id = network_id)
    affiliation(for_network_id).relationship
  end
  
end
