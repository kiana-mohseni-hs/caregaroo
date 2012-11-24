class InvitationsController < ApplicationController
  before_filter :require_user
  
  def index
    @page = 'invite'
    @invitation = Invitation.new
  end
  
  def create
    @invitations = Invitation.where("network_id = ? and email = ?", @current_user.network.id, params[:invitation][:email])
    if @invitations.size == 0
      @invitation = Invitation.new(params[:invitation])
      @invitation.send_id = @current_user.id
      @invitation.network_id = @current_user.network.id
    else
      @invitation = @invitations.first
    end
    if @invitation.save
      Resque.enqueue(InvitationMailer, @invitation.id, @current_user.id)
      redirect_to success_invitation_path({token: @invitation.token})
    else
      render "index"
    end
  end
  
  def success
  end
  
end
