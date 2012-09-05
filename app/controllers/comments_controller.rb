class CommentsController < ApplicationController  
  before_filter :require_user
  
  def index
    @comments = Comment.where("post_id = ? and created_at > ?", params[:post_id], Time.at(params[:after].to_i + 1))
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = @current_user.id
    @comment.network_id = @current_user.network_id

    respond_to do |format|
      if @comment.save
        # Resque.enqueue(CommentsActivityMailer, @comment.id)
        @comments = Comment.where("post_id = ?", @comment.post_id)
        format.html { redirect_to news_path }
        format.js
      end
    end
  end

  def destroy
    @comment = Comment.where("id = ? and user_id = ? and network_id = ?", params[:comment_id], @current_user.id, @current_user.network_id).first
    @comments = Comment.where("post_id = ?", @comment.post_id)
    
    if !@comment.nil?
      @comment.destroy
    end

    respond_to do |format|
      format.html { redirect_to news_url }
      format.js
    end
  end
  
  def full_comment
    @comment = Comment.where("id = ?", params[:comment_id]).first
    
    respond_to do |format|
      format.html { redirect_to news_path }
      format.js
    end
  end
 
end
