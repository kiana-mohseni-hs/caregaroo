class CommentsController < ApplicationController  
  before_filter :require_user
  
  def index
    @comments = Comment.where("post_id = ? and created_at > ?", params[:post_id], Time.at(params[:after].to_i + 1))
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = @current_user.id
    @post = Post.find(@comment.post_id)

    respond_to do |format|
      if @post.user_id == @current_user.id && @comment.save
        Resque.enqueue(CommentsActivityMailer, @comment.id)
        @comments = @post.comments
        @new_comment=@comments.order('updated_at').first
        format.html { redirect_to news_path }
        format.js   do
          if params[:within_event]
            if params[:from_mobile]
              render "create_in_event_mobile"
            else
              render "create_in_event"
            end
          else
            render nothing: true if mobile_device?
          end
        end
      end
    end
  end

  def destroy
    # desktop version uses params[:comment_id] -- following line adjusts for that
    params[:comment_id] =  params[:id] if mobile_device?
    @comment = @current_user.comments.find(params[:comment_id])
    @comments = @comment.post.comments
    
    @comment.destroy unless @comment.nil?

    respond_to do |format|
      format.html { redirect_to news_url }
      format.js   { render nothing: true if mobile_device? }
    end
  end
  
  # because standard restful route for destroy has been overwritten and is crowded
  # this is used by the remote call in the event details page
  def remove
    @comment = @current_user.comments.find(params[:id])
    if @comment.present?
      @post = @comment.post
      @comment.destroy
    else
      render nothing: true
    end
  end
  
  def full_comment
    @comment = Comment.where("id = ?", params[:comment_id]).first
    
    respond_to do |format|
      format.html { redirect_to news_path }
      format.js
    end
  end
=begin
  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, :notice => 'Comment was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
=end  
end
