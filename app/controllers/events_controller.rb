class EventsController < ApplicationController
  before_filter :require_user
  before_filter :prepare_for_mobile
  
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @event = Event.find(params[:id])

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

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, :notice => 'Event was successfully created.' }
        # format.mobile { redirect_to controller: "calendar", action: "index", anchor: "event", rel: "external" }
        format.mobile { redirect_to @event }
        format.json { render :json => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, :notice => 'Event was successfully updated.' }
        format.mobile { redirect_to @event }
        
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if !@event.nil?
      @event.destroy
    end

    respond_to do |format|
      format.html { redirect_to events_url }
      format.mobile { redirect_to "/calendar#calendar" }
    end
  end
end
