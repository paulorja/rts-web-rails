class EventBuildingUp < ActiveRecord::Base
  belongs_to :event
  belongs_to :cell

  def self.resolve(e)
    event_building_up = EventBuildingUp.where('event_id = ?', e.id).limit(500).first
    cell = Cell.find(event_building_up.cell_id)

    cell.building_level = cell.building_level + 1
    cell.idle = true

    user_data = UserData.where('user_id = ?', cell.user_id).first

    case cell.building_code
    when BUILDING[:storage][:code]
      user_data.storage += 1000
    when BUILDING[:house][:code]
      user_data.max_villagers += 1
    when BUILDING[:castle][:code]
      user_data.max_roads += BUILDING[:castle][:levels][cell.building_level][:roads]
    else
    end

    user_data.total_territories += 1
    user_data.idle_villagers += 1
    Cell.move_villager(cell, user_data.user.castle, cell.villagers)

    user_data.save
    cell.save

    e.destroy
    event_building_up.destroy
  end
end
