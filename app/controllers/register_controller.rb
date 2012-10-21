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
                                 relationship: "Caregiver" )
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
    #if user email already exists
    user = User.find_by_email(params[:network][:users_attributes]["0"][:email])
    
    if user
      if cookies[:auth_token] == user.auth_token || user.authenticate(params[:network][:users_attributes]["0"][:password])
        users_attributes = params[:network].delete("users_attributes")
        # logger.debug "network hash: #{params[:network].inspect}"
        # logger.debug "users_attributes hash: #{users_attributes.inspect}"
        @network = Network.new(params[:network])
        if @network.save
          @network.affiliations.first.update_attributes( {network_id: @network.id, user_id: user.id })
          user.update_attribute( :network_id, @network.id )
          Resque.enqueue(WelcomeMailer, user.id)
          cookies[:auth_token] = user.auth_token
          redirect_to register_success_path
        else
          render :action => "index", :layout => "app_no_nav"
        end
      else
        redirect_to login_path, notice: "login as #{user.email} to create a network for that user"
      end
    else
      users_attributes = params[:network].delete("users_attributes")
      affiliations_attributes = params[:network].delete("affiliations_attributes")
      @network = Network.new(params[:network])
    
      if @network.save
        user = @network.users.create( users_attributes["0"].merge({ network_id: @network.id}))
        @network.affiliations.create( { network_id: @network.id, 
                                        user_id: user.id,
                                        relationship: affiliations_attributes["0"][:relationship],
                                        role: affiliations_attributes["0"][:role] } )
        cookies[:auth_token] = user.auth_token
        Resque.enqueue(WelcomeMailer, user.id)
        if (params[:notification])
          user.notification = Notification.new(:announcement => true, :post_update => true)
        end
        
        #hack to work around creation of extra affiliation
        Affiliation.find_all_by_network_id(@network.id).each  { |a| a.destroy if ( a.relationship.nil? and a.role.nil? ) }
        
        redirect_to register_success_path
      else
        render :action => "index", :layout => "app_no_nav"
      end
    end
  end
    
  def success
      render "success", :layout => "app_no_nav"
  end
  
end
