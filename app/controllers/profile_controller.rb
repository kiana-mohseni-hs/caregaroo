class ProfileController < ApplicationController
  before_filter :require_user
  
  def info
    logger.debug "(info_profile) #{params}"
    
    if params[:user_id].nil?
      @profile = @user.profile
    
      if @profile.nil?
        @profile = Profile.new
      end
    else
      @profile = Profile.where("user_id=?", params[:user_id])
      if !@profile.nil?
        @profile = @profile.first
      end
    end
  end
  
  def edit_info
    logger.debug "(edit_info_profile) #{params}"
    
    @profile = @user.profile
    if @profile.nil?      
      @profile = Profile.new
    end

    render :edit
  end
  
  def update_info
    logger.debug "(update_profile) #{params}"
    
    @profile = @user.profile
    
    if @profile.nil?
      @profile = Profile.new(params[:profile])
      @profile.user_id = @user.id   
      if @profile.save
        redirect_to info_profile_path, :notice => 'Profile was successfully created.'
      else
        render :edit
      end
    else  
      if @profile.update_attributes(params[:profile])
        redirect_to info_profile_path, :notice => 'Profile was successfully updated.'
      else
        render :edit
      end
    end
  end
  
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