class LandpageData < ActiveRecord::Base
  attr_accessible :email, :campaign

  belongs_to :user, :primary_key => "email", :foreign_key => "email"
end
