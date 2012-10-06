class MobileController < ApplicationController
  before_filter :require_user
  before_filter :prepare_for_mobile
  
  def index
    #TODO select fewer events (e.g. current, previous and next month and update calendar when needed)
    @events = @current_user.network.events.visible
    @event = Event.new(network_id: @current_user.network.id, start_at: Time.zone.now, end_at: Time.zone.now + ( 60 * 60))
    @event_types=EventType.all
  end
  
end
