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
  
  # create community network from marketing page
  def create_min
    @network = Network.new(:network_for_who => params[:network_for_who], 
                           :network_name => params[:network_for_who] + '\'s Network')
    @network.users.build
    user = User.new(:role => User::ROLES["initiator"], 
                    :email => params[:email],
                    :password => params[:password], 
                    :network_relationship => "Coordinator"
                    :first_name => "Guest")                                    
    user.first_stage = true
    user.notification = Notification.new(:announcement => true, :post_update => true)
    @network.users[0] = user
            
    if @network.save
      cookies[:auth_token] = @network.users.first.auth_token
      Resque.enqueue(WelcomeMailer, @network.users.first.id)
      redirect_to register_success_path
    else
      render :action => "index", :layout => "app_no_nav"
    end

  end
  
  # create community network
  def create
    @network = Network.new(params[:network])
    @network.users.first.role = User::ROLES["initiator"]
    if (params[:notification])
      @network.users.first.notification = Notification.new(:announcement => true, :post_update => true)
    end
    
    if @network.save
      cookies[:auth_token] = @network.users.first.auth_token
      Resque.enqueue(WelcomeMailer, @network.users.first.id)
      redirect_to register_success_path
    else
      render :action => "index", :layout => "app_no_nav"
    end
  end
    
  def success
      render "success", :layout => "app_no_nav"
  end
    
=begin  // wizard step 
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
