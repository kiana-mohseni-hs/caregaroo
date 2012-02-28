class MessagesController < ApplicationController
  before_filter :require_user
  
  def index
    logger.debug "(index_messages)"
    
    @messages = @user.messages
    @message = Message.new
    @members = @user.get_members

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @messages }
    end
  end

  def show
=begin    
    @recent_message = Message.find(params[:id])
    @messages = Array.new
    if @recent_message.folder_id == 0
      @messages << @recent_message
    else
      @messages = @recent_message.get_related_messages
    end
=end
    @messages = Message.where("folder_id = ?", params[:id]).order("created_at")
    
    @message = Message.new
    @message.folder_id = params[:id]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @message }
    end
  end

  def reply
    logger.debug "(reply_message)"
    @message = Message.new(params[:message])
    @message.sender_id = @user.id
    if @message.save
      redirect_to :back, :notice => 'Message replied.'
    else
       flash[:error] = "Cound not reply message"
       redirect_to :back
    end
  end
  
  def create
    logger.debug "(create_message)"
    
    @message = Message.new(params[:message])
    @message.sender_id = @user.id
    @message.create_folder()
 
    if params[:recipients].nil?
      flash[:error] = "Sender or Message cannot be empty"
      @members = @user.get_members
      @messages = @user.messages
      return render :index
      # return redirect_to :back, alert => "error"
    end
      
    params[:recipients].each do |recipient|        
      @message.recipient.build(:user_id => recipient)
    end
    
    if @message.save
      redirect_to messages_path, :notice => 'Message was successfully created.'
    else
      flash[:error] = "Cound not send message"
      redirect_to :back
    end  
  end
  
=begin
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to messages_path, :notice => 'Message was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @message.errors, :status => :unprocessable_entity }
      end
    end
  end
=end
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :ok }
    end
  end
  
end
