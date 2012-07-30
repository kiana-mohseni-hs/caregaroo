class UsersController < ApplicationController  
  
  def current
    @user = User.find(current_user.id)
  end
end