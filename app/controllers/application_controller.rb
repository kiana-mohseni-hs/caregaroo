class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :expires_now
  
  private
  def current_user
    begin
      @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
    rescue
      @current_user = nil
    end
    @current_user
  end
  
  def require_user
    @current_user = current_user

    unless @current_user
      session[:referer] = request.path_parameters
      redirect_to login_path
      return false
    end

    Time.zone = @current_user.time_zone if @current_user.time_zone
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
  
  #only send special mobile version if we're developing for now
  def mobile_device?
    if Rails.env.development?
      if session[:mobile_param]  
        session[:mobile_param] == "1"  
      else  
        request.user_agent =~ /Mobile/  
      end
    else
      false
    end    
  end  
  helper_method :mobile_device?

  #only send special mobile version if we're developing for now
  def prepare_for_mobile
    if Rails.env.development?
      session[:mobile_param] = params[:mobile] if params[:mobile]
      request.format = :mobile if mobile_device?
    end
  end
  
end
