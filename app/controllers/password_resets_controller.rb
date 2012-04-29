class PasswordResetsController < ApplicationController
  def index
    render "reset", :layout => "app_no_nav"
  end

  def create
    unless params[:email] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i 
      flash[:error] = "Invalid email"
      return render "reset", :layout => "app_no_nav"
    end
    user = User.find_by_email(params[:email])
    if user 
      user.send_password_reset
      render "success", :layout => "app_no_nav"
    else
      flash[:error] = "Invalid email"
      render "reset", :layout => "app_no_nav"
    end
  end
  
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end
  
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
end
