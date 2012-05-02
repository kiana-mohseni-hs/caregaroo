class MembersController < ApplicationController
  before_filter :require_user
  
  def index
    @members = User.where("network_id = ?", @current_user.network_id).order("first_name")
  end
  
  def delete
    if @current_user.is_initiator_or_coordinator?
      @user = User.find(params[:user_id])
      if !@user.nil?
        @user.destroy 
      end
    end
    redirect_to members_path
  end
end
