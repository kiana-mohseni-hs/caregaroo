class ProfileController < ApplicationController
  before_filter :require_user
  
  def info
    if params[:user_id].nil?
      @user = @current_user
    else
      @user = User.where("id=?", params[:user_id]).first
    end
  end
  
  def edit_info
    logger.debug "(edit_info) #{params}"

=begin    
    @profile = @current_user.profile
    if @profile.nil?      
      @profile = Profile.new
    end
=end
    render "basic"
  end

=begin  
  def update_info
    logger.debug "(update_profile) #{params}"
    
    @profile = @current_user.profile
    
    if @profile.nil?
      @profile = Profile.new(params[:profile])
      @profile.user_id = @current_user.id   
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
=end  

  def update_info
    old_password = params[:old_password]
    if !old_password.empty? && !@current_user.authenticate(old_password)
      flash[:error] = "Old password incorrect."
      return redirect_to edit_info_profile_path     
    end
    
    if @current_user.update_attributes(params[:user])
      flash[:notice] = "Profile was successfully updated."
      redirect_to profile_path, :notice => 'Profile was successfully updated.'
    else
      render "basic"
    end    
  end
  
  def password   
  end
  
  def update_password
    logger.debug "(update_password) #{params}"
    
    if @current_user.update_attributes(params[:user])
      redirect_to password_profile_path, :notice => 'Password was successfully updated.'
    else
      render :action => "password"
    end    
  end
  
  def notifications    
  end
  
end