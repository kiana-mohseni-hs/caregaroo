class PasswordResetsController < ApplicationController
  def index
    session[:last_visited_page] = request.env['HTTP_REFERER'] || root_url
    render "reset", :layout => "app_no_nav"
  end

  def create
    unless params[:email] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i 
      flash[:error] = "Email is not valid"
      return render "reset", :layout => "app_no_nav"
    end
    user = User.find_by_email(params[:email])
    if user 
      user.send_password_reset
      @email = user.email
      render "success", :layout => "app_no_nav"
    else
      flash[:error] = "Email is not valid"
      render "reset", :layout => "app_no_nav"
    end
  end
  
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
    render :layout => "app_no_nav"
  end
  
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to edit_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to news_url
    else
      render :edit, :layout => "app_no_nav"
    end
  end
end
