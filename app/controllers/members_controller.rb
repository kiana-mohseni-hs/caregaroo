class MembersController < ApplicationController
  before_filter :require_user
  
  def index
    @page = 'members'
    @members = @current_user.network.users.order("first_name")
  end
  
  def delete
    if @current_user.is_initiator_or_coordinator?
      affiliation = @current_user.network.affiliations.find_by_user_id(params[:user_id])
      affiliation.destroy unless affiliation.nil?
      # try setting him to another network
      #user = User.find(params[:user_id])

    end
    redirect_to members_path
  end
  
  def update
    @message = "Failed to update"
    if @current_user.is_initiator_or_coordinator?
      @user = @current_user.network.users.find(params[:user_id])
      user_affiliation = @user.affiliation(@current_user.network.id)
      
      if !@user.nil?
        @name = @user.first_name
        if params[:checked] == 'true'
          user_affiliation.role = User::ROLES["coordinator"] 
          if user_affiliation.save
            @message = "has become a coordinator."
          end
        else
          user_affiliation.role = ''
          if user_affiliation.save
            @message = "is no longer a coordinator."
          end
        end
      end
    end
  end
end
