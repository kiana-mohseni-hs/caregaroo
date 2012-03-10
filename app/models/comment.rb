class Comment < ActiveRecord::Base
  attr_accessible :post_id, :name, :content
  belongs_to :post
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
end
