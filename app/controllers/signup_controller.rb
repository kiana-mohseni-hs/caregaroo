class SignupController < ApplicationController
  
  def new
    @invitation = Invitation.find_by_token(params[:invitation_token])
    if @invitation && @invitation.send_id
      logger.debug "(new) send_id=#{@invitation.send_id}"
      @user = User.find_by_email(@invitation.email)
      if @user.present?
        @affiliation = Affiliation.find_or_create_by_user_id_and_network_id(@user.id, @invitation.network_id)
        @user.update_attribute( :network_id, @invitation.network_id )
        redirect_to news_url
      else
        @user = User.new( network_id: @invitation.network_id,
                          email:      @invitation.email,
                          first_name: @invitation.first_name, 
                          last_name:  @invitation.last_name   )
        @sender = User.find(@invitation.send_id)
        @network_for_who = @invitation.network.network_for_who
        render "signup_form", :layout => "app_no_nav"
      end
    else
      logger.debug "#{params[:invitation_token]} will not do, that gives #{@invitation.send_id}"
      redirect_to :root
    end
    
  end
  
  def create
    @user = User.new(params[:user])
    if (params[:notification])
      @user.notification = Notification.new(:announcement => true, :post_update => true)
    end
    
    if @user.save
      @affiliation = @user.affiliations.create( relationship: params[:relationship],
                                                network_id: @user.network_id,
                                                role: "Caregiver")
      cookies[:auth_token] = @user.auth_token
      
      # delete invitation emails 
      invitation = Invitation.find_by_email_and_network_id(@user.email, @user.network_id)
      invitation.destroy unless invitation.nil?
      
      unless @user.email.match /^test\+.*/
        # send welcome email
        Resque.enqueue(WelcomeMailer, @user.id)
        Resque.enqueue(MembersActivityMailer, @user.network_id, @user.id)
      else
        logger.info ">>>> TEST: NO EMAIL WAS SENT"
      end

      redirect_to signup_success_path
    else  
      @network_for_who = params[:network_for_who]
      render "signup_form", :layout => "app_no_nav"
    end
=begin
    session[:sigup_params].deep_merge!(params[:user]) if params[:user]
    @user = User.new(session[:sigup_params])
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
      render "new"
    else
      session[:sigup_params] = session[:signup_step] = nil
      #flash[:notice] = "User created!"
      cookies[:auth_token] = @user.auth_token
      redirect_to signup_success_path
    end  
=end
  end
  
  def success
      render "success", :layout => "app_no_nav"
  end
  
end
