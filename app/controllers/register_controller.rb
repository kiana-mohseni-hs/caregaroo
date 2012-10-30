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
    if user
      # if correct password for email
      if user.authenticate(params[:network][:users_attributes]["0"][:password])
        cookies[:auth_token] = user.auth_token
        users_attributes = params[:network].delete("users_attributes")

        @network = Network.new(params[:network])
        if @network.save
          @network.affiliations.first.update_attributes( {network_id: @network.id, user_id: user.id })
          user.update_attribute( :network_id, @network.id )
          Resque.enqueue(WelcomeMailer, user.id)
          redirect_to register_success_path
        else
          render action: "new", layout: "app_no_nav"
        end
      else
        @network = Network.new(params[:network])
        @current_user = current_user
        flash[:error] = "password did not match email address"
        render action: "new", layout: "app_no_nav"
        # redirect_to login_path, notice: "login as #{user.email} to create a network for that user"
      end
    else
      
      @network = Network.new(params[:network])
    
      if @network.save
        
        # hack to fix double affiliation problem
        if @network.affiliations(true).count > 1
          @network.affiliations.first.user_id = @network.affiliations.last.user_id unless @network.affiliations.first.user_id.present? or @network.affiliations.last.user_id.blank?
          @network.affiliations.last.destroy
          @network.affiliations.first.save
        end
        
        # debugging begin
        # logger.debug "network no. #{@network.id} was just saved with affiliations and users:"
        # @network.affiliations(true).each do |a|
        #   logger.debug "affiliation #{a.attributes.inspect}"
        # end
        # @network.users(true).each do |u|
        #   logger.debug "user #{u.attributes.inspect} "
        # end
        # debugging end
        
        # set the current network of the new user to the new network
        user = @network.users.first
        user.update_attribute(:network_id, @network.id)

        # debugging begin
        # logger.debug "first of the network users had its id updated and network no. #{@network.id} now has affiliations and users:"
        # @network.affiliations(true).each do |a|
        #   logger.debug "affiliation #{a.attributes.inspect}"
        # end
        # @network.users(true).each do |u|
        #   logger.debug "user #{u.attributes.inspect} "
        # end
        # debugging end
        
        # @network.affiliations.first.update_attributes( { 
        #   network_id: @network.id, 
        #   user_id: user.id,
        #   relationship: params[:network][:affiliations_attributes]["0"][:relationship],
        #   role: params[:network][:affiliations_attributes]["0"][:role] } )
        
        # debugging begin
        # logger.debug "first of the network affiliations had its attrs updated and network no. #{@network.id} now has affiliations and users:"
        # @network.affiliations(true).each do |a|
        #   logger.debug "affiliation #{a.attributes.inspect}"
        # end
        # @network.users(true).each do |u|
        #   logger.debug "user #{u.attributes.inspect} "
        # end
        # debugging end
        
        
        cookies[:auth_token] = user.auth_token
        Resque.enqueue(WelcomeMailer, user.id)
        if (params[:notification])
          user.notification = Notification.new(:announcement => true, :post_update => true)
        end
        
        #hack to work around creation of extra affiliation
        # Affiliation.find_all_by_network_id(@network.id).each  { |a| a.destroy if ( a.relationship.nil? and a.role.nil? ) }

        # debugging begin
        # logger.debug "after hack network no. #{@network.id} now has affiliations and users:"
        # @network.affiliations(true).each do |a|
        #   logger.debug "affiliation #{a.attributes.inspect}"
        # end
        # @network.users(true).each do |u|
        #   logger.debug "user #{u.attributes.inspect} "
        # end
        # debugging end



        
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
