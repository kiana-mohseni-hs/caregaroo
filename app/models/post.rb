class Post < ActiveRecord::Base
  attr_accessible :name, :content
  has_many :comments
  belongs_to :users
end
