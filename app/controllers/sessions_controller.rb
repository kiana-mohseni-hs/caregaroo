class SessionsController < ApplicationController
  def login
    render :layout => "app_no_nav"
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end     
      # redirect_to root_url, :notice => "Logged in!"
      if session[:referer]
        referer = session[:referer]
        logger.debug "(login) referer=#{referer}"
        redirect_to(:controller => referer[:controller], :action => referer[:action] )
      else
        redirect_to news_url
      end      

    else
      flash.now.alert = "Invalid email or password"
      render "login", :layout => "app_no_nav"
    end
  end

  def destroy
    cookies.delete(:auth_token)
    session[:referer] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
