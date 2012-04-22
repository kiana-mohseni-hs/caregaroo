class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :expires_now
  
  private
  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  
  def require_user
    @current_user = current_user

    unless @current_user
      session[:referer] = request.path_parameters
      redirect_to login_path
      return false
    end
  end
  
  def require_user_admin
    @current_user = current_user

    unless @current_user
      session[:referer] = request.path_parameters
      redirect_to login_path
      return false
    end
    
    unless @current_user.email == 'mwu@caregaroo.com'
      redirect_to root_path
      return false
    end
  end

  helper_method :current_user

end
