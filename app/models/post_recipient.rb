class PostRecipient < ActiveRecord::Base
	belongs_to :user # recipient
	belongs_to :post
end
