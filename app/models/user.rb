class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :network_relationship, :first_name, :last_name, 
                  :network_id, :role, :avatar, :notification_attributes, :profile_attributes, :in_first_stage
  has_secure_password
  validates :email, :presence => true, :email_format => true, :uniqueness => true
  validates_presence_of :password, :on => :create
  validates_length_of :password, :minimum => 6, :on => :create

  validates_presence_of :network_relationship, :unless => :in_first_stage?
  validates_presence_of :first_name, :unless => :in_first_stage?
  validates_presence_of :last_name, :unless => :in_first_stage?
  # validates_presence_of :password_confirmation, :on => :create, :unless => :in_first_stage?
  attr_accessor :first_stage
  
  has_many :affiliations
  has_many :networks, through: :affiliations
  belongs_to :network
  has_many :invitations
  has_many :recipients
  has_many :messages, through: :recipients
  has_one  :profile
  has_one  :notification
  # has_many :posts, class_name: "Post", finder_sql: Proc.new {
  #     %Q{
  #       SELECT DISTINCT *
  #       FROM posts p
  #       WHERE p.network_id = #{network_id}
  #       ORDER BY p.created_at DESC 
  #     }
  # }
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
  
  def in_first_stage?
    first_stage
  end
  
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
  def is_admin?
    self.role == ROLES["admin"]
  end
  def is_initiator?
    self.role == ROLES["initiator"]
  end
  def is_coordinator?
    self.role == ROLES["coordinator"]
  end
  def is_initiator_or_coordinator?
    self.role == ROLES["initiator"] || self.role == ROLES["coordinator"]
  end
  
  def name
    (first_name || "") + ' ' + (last_name || "")
  end
  
  def current_affiliation
    affiliations.find_by_network_id(network_id)
  end
  
  def role
    current_affiliation.role
  end

  def network_relationship
    current_affiliation.relationship
  end

  
=begin  
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
=end  
end
