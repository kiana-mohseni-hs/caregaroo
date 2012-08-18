class InvitationsController < ApplicationController
  before_filter :require_user
  
  def index
    @page = 'invite'
    @invitation = Invitation.new
  end
  
  def create    
    @invitation = Invitation.new(params[:invitation])
    @invitation.send_id = @current_user.id
    @invitation.network_id = @current_user.network.id
    if @invitation.save
      Resque.enqueue(InvitationMailer, @invitation.id, @current_user.id)
      redirect_to success_invitation_path
    else
      render "index"
    end
  end
  
  def success
  end
  
end
