class Comment < ActiveRecord::Base
  attr_accessible :news_id, :name, :content
  belongs_to :news
end
