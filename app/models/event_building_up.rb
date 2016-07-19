class EventBuildingUp < ActiveRecord::Base
  belongs_to :event
  belongs_to :cell

  def self.resolve(e)
    event_building_up = EventBuildingUp.where('event_id = ?', e.id).first
    cell = Cell.find(event_building_up.cell_id)

    cell.building_level = cell.building_level + 1
    cell.idle = true


    user_data = UserData.where('user_id = ?', cell.user_id).first

    case cell.building_code
    when BUILDING[:storage][:code]
      user_data.storage += 1000
    when BUILDING[:house][:code]
      user_data.max_villagers += 1
    else

    end

    user_data.idle_villagers = user_data.idle_villagers + 1
    user_data.save

    cell.save
    e.destroy
    event_building_up.destroy
  end
end
