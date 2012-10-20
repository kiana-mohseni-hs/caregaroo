class NetworkController < ApplicationController
  before_filter :require_user
  
  def edit
    @page = 'network_info'
    if @current_user.is_initiator_or_coordinator?
      @network = @current_user.network
    else
      redirect_to news_path
    end
  end

  def save
    if @current_user.is_initiator_or_coordinator?
      @current_user.network.update_attributes(params[:network])
      redirect_to network_edit_path, :notice => 'Network info was successfully updated.'
    else
      redirect_to network_edit_path, :alert => "Network info was not saved."   
    end
    
  end
  
  def switch
    @page = 'network_info'
  end
  
  def switch_save
    @current_user.update_attribute( :network_id, params[:user][:network_id] ) if @current_user.networks.exists?(id: params[:user][:network_id])
    redirect_to news_url
  end
  
end
