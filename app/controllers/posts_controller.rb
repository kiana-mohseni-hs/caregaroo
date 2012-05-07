class PostsController < ApplicationController
  before_filter :require_user
  
  def index
    @page = 'posts'
    @posts = Post.where("network_id = ?", @current_user.network).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @posts }
    end 
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(params[:post])
    @post.network_id = @current_user.network_id
    @post.user_id = @current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to news_path }
      end
    end
  end

  def destroy
    @post = Post.where("id = ? and user_id = ?", params[:id], @current_user.id).first
    @post.destroy

    respond_to do |format|
      format.html { redirect_to news_path }
      format.json { head :ok }
    end
  end
  
  def comments
    @comments = Comment.where("post_id = ?", params[:post_id])
    @post_id = params[:post_id]
    
    respond_to do |format|
      format.html { redirect_to news_path }
      format.js
    end
  end
  
  def full_post
    @post = Post.where("id = ? and network_id = ?", params[:id], @current_user.network_id).first
    
    respond_to do |format|
      format.html { redirect_to news_path }
      format.js
    end
  end
  
end
