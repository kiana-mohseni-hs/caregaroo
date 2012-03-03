class Message < ActiveRecord::Base
    belongs_to :user, :foreign_key => "sender_id", :class_name => "User"
    has_many :recipients
    has_many :authors, :through => :recipients
    belongs_to :folder, :foreign_key => "folder_id", :class_name => "Folder"
    
end
