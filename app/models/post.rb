class Post < ActiveRecord::Base
  attr_accessible :name, :content
  has_many :comments, :dependent => :destroy
  belongs_to :user
end
