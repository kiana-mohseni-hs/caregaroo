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
  
  def new
    network_name = params[:network_for_who] || ""
    network_name += "'s Network" unless params[:network_for_who].blank?
    @network = Network.new( network_for_who: params[:network_for_who], 
                            name:            network_name              )

    
    
    if @current_user = current_user
      @network.users.build( { email:      current_user.email, 
                              last_name:  current_user.last_name,
                              first_name: current_user.first_name } )
      @readonly = true
    else
      @network.users.build( { email:      params[:email] || "" } )
      @readonly = false
    end
    @network.affiliations.build( role:         User::ROLES["initiator"],
                                 relationship: "Caregiver"               )
    @network.users[0].notification = Notification.new(:announcement => true, :post_update => true)
    
    render :action => "new", :layout => "app_no_nav"
  end


  
  # create community network
  def create
    #if user email already exists
    user = User.find_by_email(params[:network][:users_attributes]["0"][:email])
    logger.info ">>0 #{user.try :email}"
    if user
      # if correct password for email
      if user.authenticate(params[:network][:users_attributes]["0"][:password])
        logger.info ">>1 #{user} authed"
        cookies[:auth_token] = user.auth_token
        users_attributes = params[:network].delete("users_attributes")

        @network = Network.new(params[:network])
        if @network.save
          logger.info ">>2 @network saved!"
          session[:landing_email] = nil
          # looks very wrong \/
          @network.affiliations.first.update_attributes( {network_id: @network.id, user_id: user.id })
          user.update_attribute( :network_id, @network.id )
          Resque.enqueue(WelcomeMailer, user.id)
          redirect_to register_success_path
        else
          logger.info ">>3 network nonsaved"
          @network.users.build( { email:      user.email, 
                                  last_name:  user.last_name,
                                  first_name: user.first_name } )
          @readonly = true
          render action: "new", layout: "app_no_nav"
        end
      else
        logger.info ">>4 #{user} non-authed"
        @network = Network.new(params[:network])
        @network.errors.add(:password, "did not match email address" )
        @current_user = current_user
        render action: "new", layout: "app_no_nav"
      end
    else
      
      # could have param "affiliations_attributes" set to null at some point to have it 
      @network = Network.new(params[:network])
      logger.info ">>5 new user #{params[:network].inspect} "
      if @network.save
        # set the current network of the new user to the new network
        user = @network.users.first
        user.update_attribute(:network_id, @network.id)
        
        @network.affiliations.first.update_attributes( { 
          network_id: @network.id, 
          user_id: user.id,
          relationship: params[:network][:affiliations_attributes]["0"][:relationship],
          role: params[:network][:affiliations_attributes]["0"][:role] } )
        
        # hack to fix double affiliation problem
        if @network.affiliations(true).count > 1
          @network.affiliations.last.delete # dont trigger after_destroy's
        end

        
        cookies[:auth_token] = user.auth_token
        Resque.enqueue(WelcomeMailer, user.id)
        if (params[:notification])
          user.notification = Notification.new(:announcement => true, :post_update => true)
        end
                
        redirect_to register_success_path
      else
        render :action => "new", :layout => "app_no_nav"
      end
    end
  end
    
  def success
      render "success", :layout => "app_no_nav"
  end
  
end
