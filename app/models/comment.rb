class Comment < ActiveRecord::Base
  attr_accessible :post_id, :name, :content
  belongs_to :post
  has_one :user
end
