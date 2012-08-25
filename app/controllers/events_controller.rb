class EventsController < ApplicationController
  before_filter :require_user
  before_filter :prepare_for_mobile, except: [:create]
  
  def index
    @events = Event.visible

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @event = Event.includes( :users, :post, { comments: :user } ).find( params[:id] )
    @creator = @event.creator || @current_user
    @comment = Comment.new
    
    respond_to do |format|
      format.html # show.html.erb
      format.mobile 
    end
  end

  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @event = Event.find(params[:id])
    @event_types=EventType.all
  end

  def create
    @event = Event.new(params[:event])
    @event.creator = @current_user
    @event.updater = @current_user
    @event.network_id ||= @current_user.network.id

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, :notice => 'Event was successfully created.' }
        format.json { render :json => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    @event.updater = @current_user

    respond_to do |format|
      if @event.update_attributes(params[:event])
        if params[:next] == "index"
          format.html { redirect_to calendar_url }
        else
          format.html { redirect_to @event, :notice => 'Event was successfully updated.' }
          format.mobile { redirect_to @event }
        end
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def cancel
    @event = Event.find(params[:id])
    if !@event.canceled?
      @event.cancel(@current_user.id)
    end

    respond_to do |format|
      format.html { redirect_to events_url }
      format.mobile { redirect_to "/#calendar" }    #     calendar_url(2012,06)
    end
  end


  def destroy
    @event = Event.find(params[:id])
    if !@event.nil?
      @event.destroy
    end

    respond_to do |format|
      format.html { redirect_to events_url }
      format.mobile { redirect_to "/#calendar" }    #     calendar_url(2012,06)
    end
  end
end
