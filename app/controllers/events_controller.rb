class EventsController < ApplicationController
  before_filter :require_user
  before_filter :set_page
  before_filter :prepare_for_mobile, except: [:create]
  before_filter :combine_datetime, only: [:create, :update]
  
  def index
    visible_events = @current_user.network.events.visible.order("start_at")
    events_count = visible_events.count
    future_events = visible_events.future
    per_page = 12
    @current_page = params[:page] || 0
    offset = events_count - future_events.count + @current_page.to_i * per_page
    if offset > 0
      @events = visible_events.limit(per_page).offset(offset)
      @prev_available = true
    else
      @events = visible_events.limit(per_page+ offset)
      @prev_available = false
    end
    
    @today = Date.today
    @dateswithevents = []
    
    first_day = if (@current_page.to_i == 0) then @today
                elsif @events.empty?         then nil
                else                              @events.first.start_at.to_date
                end
    
    unless first_day.nil?
      previous_multi_day = visible_events.end_after_date(first_day).start_before_date(first_day)
      @events = previous_multi_day + @events
      unless @events.empty?
        (first_day..@events.max_by(&:end_at).end_at.to_date).each do |d| 
          @events.each { |e| @dateswithevents << d if e.is_on?(d) }
        end
      end
      @dateswithevents.uniq!
    end
        
    @display_empty_today_banner = ((@current_page.to_i == 0) and (!@dateswithevents.include?(@today)))
    
    @next_available = events_count > (offset+ per_page)
    @prev_link = "?page=" << (@current_page.to_i- 1).to_s
    @next_link = "?page=" << (@current_page.to_i+ 1).to_s
  end

  def show
    @event = Event.includes( :users, :post, { comments: :user } ).find( params[:id] )
    @event_type = @event.event_type.present? ? "(" << @event.event_type.name << ")" : ""
    @creator = @event.creator || @current_user
    @comment = Comment.new
    
    respond_to do |format|
      format.html # show.html.erb
      format.mobile 
    end
  end

  def new
    @event = Event.new(network_id: @current_user.network.id)
    @event_types=EventType.all

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
        format.html { @event_types=EventType.all; render :action => "new" }
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    params[:event][:updated_by_id] = @current_user.id
    
    respond_to do |format|
      if @event.update_attributes(params[:event])
          format.html { redirect_to @event, :notice => 'Event was successfully updated.' }
          format.mobile { redirect_to @event }
      else
        format.html { @event_types=EventType.all; render :action => "edit" }
      end
    end
  end

  def update_user
    @message = "Failed to update"
    @event = Event.find(params[:id])

    if params[:checked] == "true"
      @current_user.events << @event
      @message = "Signed up"
    else
      @current_user.events.delete(@event)
      @message = "Signed off"
    end
  end
  
  def cancel
    @event = Event.find(params[:id])
    if !@event.canceled?
      @event.cancel(@current_user.id)
    end

    respond_to do |format|
      format.js {}
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
  
  def set_page
    @page = 'events'
  end
  
  def combine_datetime
    params[:event][:start_at] = Timeliness.parse(params[:event][:start_at_date] << ' ' << params[:event][:start_at], :datetime, zone: :local)
    params[:event].delete(:start_at_date)
    params[:event][:end_at] = Timeliness.parse(params[:event][:end_at_date] << ' ' << params[:event][:end_at], :datetime, zone: :local)
    params[:event].delete(:end_at_date)
  end
end
