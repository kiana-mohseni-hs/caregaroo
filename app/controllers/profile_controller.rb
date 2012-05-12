class ProfileController < ApplicationController
  before_filter :require_user
  
  def info
    if params[:user_id].nil?
      @user = @current_user
    else
      @user = User.where("id=? and network_id=?", params[:user_id], @current_user.network_id).first
    end
  end
  
  def edit_info
    @user = @current_user
    if @user.notification.nil?
      @user.notification = Notification.new
    end
    render "edit"
  end

  def update_info
    old_password = params[:old_password]
    if !old_password.empty? && !@current_user.authenticate(old_password)
      return redirect_to edit_info_profile_path, :alert => "Old password incorrect."   
    end
    
    if @current_user.update_attributes(params[:user])
      redirect_to profile_path, :notice => 'Profile was successfully updated.'
    else
      render "edit"
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