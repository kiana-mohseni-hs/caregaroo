class SignupController < ApplicationController
  
  def new
    logger.debug "(new_signup) #{params[:invitation_token]}"
      
    session[:signup_params] ||= {}
    @user = User.new(session[:signup_params])
    
    @invitations = Invitation.find_by_token(params[:invitation_token])
    if @invitations && @invitations.send_id
      logger.debug "(new) send_id=#{@invitations.send_id}"
      
      @sender = User.find(@invitations.send_id)
      @network = @sender.network
      logger.debug "(new_signup) network=#{@network.network_name}"
      @user.network_id = @sender.network.id
      session[:signup_params]['email'] = @invitations.email 
      session[:signup_params]['first_name'] = @invitations.first_name 
      session[:signup_params]['last_name'] = @invitations.last_name 
    else
      redirect_to :root
    end
    
  end
  
  def create
    logger.debug "(create_signup) #{params[:user]}"    
    @user = User.new(params[:user])
    if @user.save
      cookies[:auth_token] = @user.auth_token
      logger.debug "(create_signup) token=#{@user.auth_token}"
      render "success"
    else
      render :action => "new"
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
  end
  
end
