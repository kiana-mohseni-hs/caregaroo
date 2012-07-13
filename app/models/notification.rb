class Notification < ActiveRecord::Base
  attr_accessible :announcement, :post_update
  belongs_to :user
end
