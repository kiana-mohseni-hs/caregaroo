class MembersController < ApplicationController
  before_filter :require_user
  
  def index
    @members = User.where("network_id = ?", @current_user.network_id).order("first_name")
  end
end
