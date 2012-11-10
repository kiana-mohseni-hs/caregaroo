class PostsController < ApplicationController
  before_filter :require_user
  
  def index
    @page = 'posts'
    @posts = @current_user.network.posts.visible_to(@current_user).includes(:user).includes(:comments)
    @err = params[:err]
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    begin
    @post = Post.new(params[:post])
    rescue Exception => e
      if e.message == 'too large'
        redirect_to news_path(err: 'file')
        return
      end
      raise e
    end
    
    @post.network_id = @current_user.network_id
    @post.user_id = @current_user.id
    @recipients = params[:recipient_list_condensed].split(',').map{|x| x.to_i}

    respond_to do |format|
      Post.transaction do
        if @recipients && @recipients.size > 0 && @post.save
          # is rated E for Everyone?
          if @recipients.include? 0
            PostRecipient.create!(post_id: @post.id, user_id: 0)
          else
            @recipients.each do |user_id|
              PostRecipient.create!(post_id: @post.id, user_id: user_id)
            end
            PostRecipient.create!(post_id: @post.id, user_id: @current_user.id)
          end
          # Resque.enqueue(NewsActivityMailer, @post.id)
        end
      end
      if @post.persisted?
        format.html { redirect_to news_path }
      else
        format.html { redirect_to news_path(err: 'file') } if @post.errors[:photo].any?
      end
    end
  end

  def destroy
    # desktop version uses params[:post_id] -- following line adjusts for that
    params[:post_id] =  params[:id] if mobile_device?
    @post = @current_user.posts.find(params[:post_id])
    @post.destroy unless @post.nil?

    respond_to do |format|
      format.html { redirect_to news_path }
      format.js   { render nothing:true }
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
