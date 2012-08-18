class NetworkController < ApplicationController
  before_filter :require_user
  
  def image
    if @current_user.is_initiator_or_coordinator?
      @network = @current_user.network
    else
      redirect_to news_path
    end
  end

  def upload
    if @current_user.is_initiator_or_coordinator?
      @current_user.network.update_attributes(params[:network])
    end
    redirect_to network_image_path
  end
  
end
