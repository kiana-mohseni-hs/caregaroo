class CreateEventTypes < ActiveRecord::Migration
  def change
    create_table :event_types do |t|
      t.string :name
    end
    
    EventType.create(name: "Appointment")
    EventType.create(name: "Ride")
    EventType.create(name: "Meal")
    EventType.create(name: "Visit")
    EventType.create(name: "Other")
    
  end
end
