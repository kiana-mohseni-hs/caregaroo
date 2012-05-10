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
    mail :to => @user.email, :subject => "Welcome to Caregaroo"
  end
  
   def news_activity(post_id)
    @post = Post.find(post_id)
    @members = User.joins(:notification).where("users.network_id = ?", @post.user.network.id)
    mail :to => @user.email, :subject => "Recent activity on #{@post.network.network_for_who}'s network"
  end
  
end
