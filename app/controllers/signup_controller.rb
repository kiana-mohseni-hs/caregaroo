class SignupController < ApplicationController
  
  def new    
    @user = User.new
    @invitations = Invitation.find_by_token(params[:invitation_token])
    if @invitations && @invitations.send_id
      logger.debug "(new) send_id=#{@invitations.send_id}"
      
      @sender = User.find(@invitations.send_id)
      @network_for_who = @sender.network.network_for_who
      @user.network_id = @sender.network.id
      @user.email = @invitations.email
      @user.first_name = @invitations.first_name 
      @user.last_name = @invitations.last_name 
      render "signup_form", :layout => "app_no_nav"
    else
      logger.debug "#{params[:invitation_token]} will not do, that gives #{@invitations.send_id}"
      redirect_to :root
    end
    
  end
  
  def create
    @user = User.new(params[:user])
    if (params[:notification])
      @user.notification = Notification.new(:announcement => true, :post_update => true)
    end
    
    if @user.save
      cookies[:auth_token] = @user.auth_token
      Resque.enqueue(WelcomeMailer, @user.id)
      Resque.enqueue(MembersActivityMailer, @user.network_id, @user.id)
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
