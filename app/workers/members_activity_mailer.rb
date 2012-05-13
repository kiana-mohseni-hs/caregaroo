class MembersActivityMailer
  @queue = :mailer_queue
  def self.perform(network_id, member_id)
    member = User.find(member_id)
    network = Network.find(network_id)
    members = User.joins(:notification).where("users.network_id = ? and notifications.post_update = ? and users.id <> ?", network_id, true, member_id)
    members.each do |m|
      UserMailer.members_activity(member, m.email, network.network_for_who).deliver
    end
  end
end