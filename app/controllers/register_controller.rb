class RegisterController < ApplicationController
  respond_to :html, :js, :json
    
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
  
  def index
    @network = Network.new
    @network.users.build
  end
  
  def create
    @network = Network.new(params[:network])
    @network.users.first.role = 'ADMIN'
    
    if @network.save
      cookies[:auth_token] = @network.users.first.auth_token
      logger.debug "(create) token=#{@network.users.first.auth_token}"
      render "success"
    else
      render :action => "index"
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