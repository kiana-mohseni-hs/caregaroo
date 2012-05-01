class MembersController < ApplicationController
  before_filter :require_user
  
  def index
    @members = User.where("network_id = ?", @current_user.network_id).order("first_name")
  end
  
  def delete
    @user = User.find(params[:user_id])
    @user.destroy
    @post = Post.find_user_id(params[:user_id])
    @post.destroy
    @post = Comment.find_user_id(params[:user_id])
    @post.destroy
    redirect_to members_path
  end
end
