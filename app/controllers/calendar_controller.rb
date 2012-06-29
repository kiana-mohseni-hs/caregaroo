class CalendarController < ApplicationController
  before_filter :require_user
  before_filter :prepare_for_mobile
  
  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month)
    @page = 'calendar'
    
    # code above came with event-calendar gem for desktop calendar
    # code below written for mobile calendar
    
    #TODO select fewer events (e.g. current, previous and next month and update calendar when needed)
    @events = @current_user.network.events
  end
  
end
