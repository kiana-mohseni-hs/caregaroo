class News < ActiveRecord::Base
  attr_accessible :name, :content
  has_many :comments
end
