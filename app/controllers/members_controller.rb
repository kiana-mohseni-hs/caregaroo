class MembersController < ApplicationController
  before_filter :require_user
  
  def index
    @users = User.where("network_id = ?", @user.network_id).order("first_name")
  end
end
