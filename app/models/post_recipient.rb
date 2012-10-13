class PostRecipient < ActiveRecord::Base
  attr_accessible :user_id, :post_id
  belongs_to :user # recipient
  belongs_to :post
end
