class RegisterController < ApplicationController
  respond_to :html, :js, :json

  # create signup    
  def signup
     @pilot_signup = PilotSignup.new(params[:pilot_signup])
     @pilot_signup.save
     if @pilot_signup.signup_type == 'ebook'
       cookies[:ebook] = "1"
     elsif @pilot_signup.signup_type == 'pilot'
       cookies[:pilot] = "1"
     end
     respond_with( @pilot_signup, :layout => false )
  end
  
  # display community network form
  def index
    @network = Network.new
    @network.users.build
    render :action => "index", :layout => "app_no_nav"
  end
  
  # create community network
  def create
    @network = Network.new(params[:network])
    @network.users.first.role = 'ADMIN'
    if (params[:notification])
      @network.users.first.notification = Notification.new(:announcement => true)
    end
    
    if @network.save
      cookies[:auth_token] = @network.users.first.auth_token
      logger.debug "(create) token=#{@network.users.first.auth_token}"
      render "success", :layout => "app_no_nav"
    else
      render :action => "index", :layout => "app_no_nav"
    end
    
    
=begin    
    session[:signup_params].deep_merge!(params[:user]) if params[:user]
    @user = User.new(session[:signup_params])
    @user.current_step = session[:signup_step]
    
    if params[:back_button]
      @user.previous_step
    elsif @user.last_step?
      @user.save
    else
      @user.next_step
    end
    
    session[:signup_step] = @user.current_step 


    if @user.new_record?
      render "success"
    else
      session[:signup_params] = session[:signup_step] = nil
      #flash[:notice] = "User created!"
      cookies[:auth_token] = @user.auth_token
      #redirect_to register_success_path
      render "success"
#    end  
=end
  end
  
  def success
  end
  
end
