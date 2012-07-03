class Profile < ActiveRecord::Base
  attr_accessible :location, :phone_home, :phone_work, :phone_work_ext, :bio, :phone_mobile
  belongs_to :user
end
