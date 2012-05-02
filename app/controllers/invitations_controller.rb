class InvitationsController < ApplicationController
  before_filter :require_user
  
  def index
    @page = 'invite'
    @invitation = Invitation.new
  end
  
  def create    
    @invitation = Invitation.new(params[:invitation])
    @invitation.send_id = @current_user.id
    if @invitation.save
      UserMailer.pilot_invitation(@invitation, @current_user).deliver
      redirect_to success_invitation_path, :notice => "Invitation sent!"
    else
      render "index"
    end
  end
  
  def success
  end
  
end
