class UserMailer < ActionMailer::Base
  default :from => "do-not-reply@caregaroo.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Your Caregaroo Password Reset Request"
  end
  
  def member_invitation(invitation_id, sender_id)
    @invitation = Invitation.find(invitation_id)
    @sender = User.find(sender_id)
      
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    #attachments.inline['image.jpg'] = File.read('/path/to/image.jpg')
    mail :to => "#{@invitation.first_name} <#{@invitation.email}>", :subject => "Join me on Caregaroo"
  end
  
  def welcome_initator(user_id)
    @user = User.find(user_id)
    @token = generate_token(@user.email)
    @recipient_email = @user.email
    mail :to => @recipient_email, :subject => "Welcome to Caregaroo"
  end
  
  def news_activity(post, member, network_for_who)
    @network_for_who = network_for_who
    @post = post
    @token = generate_token(member.email)
    @recipient_email = member.email
    mail(:to => @recipient_email, :subject => "Recent activity on #{network_for_who}'s network")
  end
  
  private 
  def generate_token(email)
    Digest::SHA256.hexdigest(email.downcase + UNSUBSCRIBED_SECRET_KEY)
  end
  
end
