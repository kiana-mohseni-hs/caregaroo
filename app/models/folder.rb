class Folder < ActiveRecord::Base
  has_many :message
end
