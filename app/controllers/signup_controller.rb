class SignupController < ApplicationController
  
  def new
    logger.debug "(new) #{params[:invitation_token]}"
      
    session[:sigup_params] ||= {}
    @user = User.new(session[:sigup_params])
    @user.current_step = session[:signup_step]
    
    @invitations = Invitation.find_by_token(params[:invitation_token])
    if @invitations
      logger.debug "(new) #{@invitations.email}"
      session[:sigup_params]['email'] = @invitations.email 
      session[:sigup_params]['first_name'] = @invitations.first_name 
      session[:sigup_params]['last_name'] = @invitations.last_name 
    end
  end
  
  def create
    logger.debug "(create) #{params[:user]}"    
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
  end
  
  def success
  end
  
end
