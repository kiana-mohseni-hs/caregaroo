class MessagesController < ApplicationController
  before_filter :require_user
  
  def index
    @messages = @user.latest_messages
    @message = Message.new
    @members = @user.get_members

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @messages }
    end
  end

  def show
    @messages = []
    if @user.messages.find_by_folder_id(params[:id])
      @messages = Message.where("folder_id = ?", params[:id]).order("created_at")
    end      
    
    @message = Message.new
    @message.folder_id = params[:id]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @message }
    end
  end

  def reply
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
      @message.recipients.build(:user_id => recipient)
    end
    
    @message.recipients.build(:user_id => @user.id)
    
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
