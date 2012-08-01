class PostsController < ApplicationController
  before_filter :require_user
  
  def index
    @page = 'posts'
    @posts = @current_user.network.posts.includes(:user).includes(:comments).order("updated_at DESC")
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
        Resque.enqueue(NewsActivityMailer, @post.id)
        format.html { redirect_to news_path }
      end
    end
  end

  def destroy
    # desktop version uses params[:post_id] -- following line adjusts for that
    params[:post_id] =  params[:id] if mobile_device?
    @post = current_user.posts.find(params[:post_id])
    @post.destroy unless @post.blank?

    respond_to do |format|
      format.html { redirect_to news_path }
      format.js
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
    @post = Post.where("id = ? and network_id = ?", params[:post_id], @current_user.network_id).first
    
    respond_to do |format|
      format.html { redirect_to news_path }
      format.js
    end
  end
  
end
