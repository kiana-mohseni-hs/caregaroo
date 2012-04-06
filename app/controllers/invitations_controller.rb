class InvitationsController < ApplicationController
  before_filter :require_user
  
  def index
    @invitation = Invitation.new
  end
  
  def create    
    @invitations = Invitation.new(params[:invitation])
    @invitations.send_id = @user.id
    if @invitations.save
      UserMailer.pilot_invitation(@invitations).deliver
      redirect_to success_invitation_path, :notice => "Invitation sent!"
    else
      render "new"
    end
  end
  
  def success
  end
  
end
