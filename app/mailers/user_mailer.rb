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
  
  def pilot_invitation(pilot, inviter)
    @pilot = pilot
    @inviter = inviter
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    #attachments.inline['image.jpg'] = File.read('/path/to/image.jpg')
    mail :to => "#{pilot.first_name} #{pilot.first_name} <#{pilot.email}>", :subject => "Join me on Caregaroo"
  end
  
end
