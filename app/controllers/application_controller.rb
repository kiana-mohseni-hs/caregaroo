class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  
  def require_user
    @user = current_user

    unless @user
      session[:referer] = request.path_parameters
      redirect_to login_path
      return false
    end
  end
  
  def require_user_admin
    @user = current_user

    unless @user
      session[:referer] = request.path_parameters
      redirect_to login_path
      return false
    end
    
    unless @user.email == 'mwu@caregaroo.com'
      redirect_to root_path
      return false
    end
  end

  helper_method :current_user

end
