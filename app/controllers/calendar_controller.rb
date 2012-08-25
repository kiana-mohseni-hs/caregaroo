class CalendarController < ApplicationController
  before_filter :require_user

  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month)
    @page = 'calendar'
    
    @events = Event.visible.order("start_at").page(params[:page]).per_page(10)
  end
  
end

# .where(['start_at > ?', Time.now.beginning_of_day])
