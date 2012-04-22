class InvitationsController < ApplicationController
  before_filter :require_user
  
  def index
    @invitation = Invitation.new
    render :layout => false
  end
  
  def create    
    @invitation = Invitation.new(params[:invitation])
    @invitation.send_id = @current_user.id
    if @invitation.save
      UserMailer.pilot_invitation(@invitation).deliver
      redirect_to success_invitation_path, :notice => "Invitation sent!"
    else
      render "index.js.erb", :layout => false
    end
  end
  
  def success
    render :layout => false
  end
  
end
