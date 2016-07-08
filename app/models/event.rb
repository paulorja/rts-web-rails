class Event < ActiveRecord::Base

  enum event_type: [:building_up]






  def self.resolve_events
    events = Event.where('end_time < ?', Time.now.to_i).order('end_time ASC')
    events.each do |e|

      case e.event_type
        when 'building_up'
          event_building_up = EventBuildingUp.where('event_id = ?', e.id).first
          cell = Cell.find(event_building_up.cell_id)

          cell.building_level = cell.building_level + 1

          cell.save

          e.destroy
          event_building_up.destroy
        else
          raise 'Fodeo'
      end
    end
  end

end
