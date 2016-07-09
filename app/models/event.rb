class Event < ActiveRecord::Base

  enum event_type: [:building_up]






  def self.resolve_events
    events = Event.where('end_time < ?', Time.now.to_i).order('end_time ASC')
    events.each do |e|

    case e.event_type
      when 'building_up'
        EventBuildingUp.resolve e
      else
        raise 'Fodeo'
    end
    end
  end

end
