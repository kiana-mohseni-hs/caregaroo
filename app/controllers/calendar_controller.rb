class CalendarController < ApplicationController
  before_filter :require_user

  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month)
    @page = 'calendar'
    # up to here was code from the event_calendar gem
    
    #pagination code
    visible_events = @current_user.network.events.visible.order("start_at")
    events_count = visible_events.count
    future_events = visible_events.future
    per_page = 10
    @current_page = params[:page] || 0
    offset = events_count - future_events.count + @current_page.to_i * per_page
    if offset > 0
      @events = visible_events.limit(per_page).offset(offset)
      @prev_available = true
    else
      @events = visible_events.limit(per_page+ offset)
      @prev_available = false
    end
    
    @next_available = events_count > (offset+ per_page)
    @prev_link = "?page=" << (@current_page.to_i- 1).to_s
    @next_link = "?page=" << (@current_page.to_i+ 1).to_s
    
    
  end
  
end
