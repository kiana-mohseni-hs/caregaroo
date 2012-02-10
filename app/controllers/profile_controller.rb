class ProfileController < ApplicationController
  before_filter :require_user
  
  def index
    @user
  end

  def update_basic
    logger.debug "(update_basic_profile) #{params}"
    
    if @user.update_attributes(params[:user])
      redirect_to profile_path, :notice => 'User was successfully updated.'
    else
      render :action => "index"
    end    
  end
  
  
  def info
  end
  
  def password   
    @user 
  end
  
  def update_password
    logger.debug "(update_password) #{params}"
    
    if @user.update_attributes(params[:user])
      redirect_to password_profile_path, :notice => 'Password was successfully updated.'
    else
      render :action => "password"
    end    
  end
  
  def notifications    
  end
  
end