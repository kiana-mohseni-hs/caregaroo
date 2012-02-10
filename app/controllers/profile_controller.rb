class ProfileController < ApplicationController
  before_filter :require_user
  
  def index
    @user
  end

  def update_basic
    logger.debug "(update_basic_profile) #{params}"

    @user.update_attributes(params[:user])
    logger.debug "(update_basic_profile) #{@user.first_name}"
    
    if @user.save
      redirect_to profile_path, notice: 'User was successfully created.'
    else
      redirect_to :back
    end    
  end
  
  def info
  end
  
  def password    
  end
  
  def notifications    
  end
  
end