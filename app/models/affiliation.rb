class Affiliation < ActiveRecord::Base
  belongs_to :network
  belongs_to :user
  attr_accessible :relationship, :role, :network_id, :user_id

  after_destroy :fix_user, :remove_his_post_recipient

  def fix_user
    #require 'debugger'; debugger
    aff = user.affiliations.all[0]
    if aff
      user.update_attribute :network_id, aff.network_id
    else
      user.update_attribute :network_id, nil
    end
  end

  def remove_his_post_recipient
    posts_with_user = network.posts.visible_to(user).map &:id
    pss = PostRecipient.where(:post_id=> posts_with_user).where(:user_id => user.id)
    pss.each{|ps| ps.destroy}
  end

end
