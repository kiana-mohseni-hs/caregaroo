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
    @network.affiliations.build
    render :action => "index", :layout => "app_no_nav"
  end
  
  # redirect from home, present final step to build network
  def create_min
    network_name = params[:network_for_who] 
    network_name += "'s Network" unless params[:network_for_who].blank?
    @network = Network.new(:network_for_who => params[:network_for_who], 
                           :name => network_name)
    @network.users.build
    @network.affiliations.build( role: User::ROLES["initiator"],
                                 relationship: "Coordinator" )
    user = User.new(:email => params[:email],
                    :password => params[:password], 
                    :first_name => "")
    user.notification = Notification.new(:announcement => true, :post_update => true)
    @network.users[0] = user
            
    # let's not create from here anymore so we can detect the timezone
    #if @network.save
    #  cookies[:auth_token] = @network.users.first.auth_token
    #  Resque.enqueue(WelcomeMailer, @network.users.first.id)
    #  redirect_to register_success_path
    #else
      render :action => "index", :layout => "app_no_nav"
    #end

  end
  
  # create community network
  def create
    @network = Network.new(params[:network])
    if (params[:notification])
      @network.users.first.notification = Notification.new(:announcement => true, :post_update => true)
    end
    
    if @network.save
      @network.users.first.update_attribute( :network_id, @network.id)
      @network.affiliations.first.update_attributes( {network_id: @network.id, user_id: @network.users.first.id })
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
  
end
