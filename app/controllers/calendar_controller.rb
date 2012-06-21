class CalendarController < ApplicationController
  before_filter :require_user
  before_filter :prepare_for_mobile
  
  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month)
    @page = 'calendar'
    
    @events = @current_user.network.events
  end
  
end
