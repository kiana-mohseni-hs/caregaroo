class NotificationsController < ApplicationController
  
  def unsubscribe
    email = params[:e]
    token = params[:token]
    if !email.nil? && !token.nil?
      expected_token = Digest::SHA256.hexdigest(email.downcase + UNSUBSCRIBED_SECRET_KEY)
      if (expected_token == token)
        user = User.find_by_email(email)
        if !user.nil?
          user.notification.update_attributes( :post_update => 0 )
        else
          invitation = Invitation.find_by_email(email)
          invitation.destroy unless invitation.nil?
        end
      end
    end
    
    render "success", :layout => "app_no_nav"
  end
  
end