class InvitationsController < ApplicationController
  
  def new
    @invitations = Invitation.new
  end
  
  def create
    @invitations = Invitation.new(params[:invitation])
    if @invitations.save
      UserMailer.pilot_invitation(@invitations).deliver
      redirect_to pilot_success_url, :notice => "Signed up!"
    else
      render "new"
    end
  end
  
  def success
  end
  
end
