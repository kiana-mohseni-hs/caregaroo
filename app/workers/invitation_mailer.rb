class InvitationMailer
  @queue = :mailer_queue
  def self.perform(invitation_id, sender_id)
    UserMailer.member_invitation(invitation_id, sender_id).deliver
  end
end