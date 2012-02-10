class Comment < ActiveRecord::Base
  attr_accessible :post_id, :name, :content
  belongs_to :posts
  has_one :users
end
