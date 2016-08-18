class EventBuildingUp < ActiveRecord::Base
  belongs_to :event
  belongs_to :cell

  def self.resolve(e)
    event_building_up = EventBuildingUp.where('event_id = ?', e.id).first
    cell = Cell.find(event_building_up.cell_id)
    building = Building.get_building(cell.building_code)

    cell.building_level = cell.building_level + 1
    cell.idle = true

    user_data = UserData.where('user_id = ?', cell.user_id).first

    case cell.building_code
    when BUILDING[:storage][:code]
      user_data.storage += BUILDING[:storage][:levels][cell.building_level][:storage]
    when BUILDING[:house][:code]
      user_data.max_pop += BUILDING[:house][:levels][cell.building_level][:population]
    when BUILDING[:castle][:code]
      user_data.max_roads += BUILDING[:castle][:levels][cell.building_level][:roads]
    else
    end

    user_data.score += building[:levels][cell.building_level][:score].to_i
    user_data.total_territories += 1 if cell.building_level == 1

    if cell.is_recourse_building
      user_data.food_villagers += 1 if cell.is_farm
      user_data.wood_villagers += 1 if cell.is_tree
      user_data.stone_villagers += 1 if cell.is_stone
      user_data.gold_villagers += 1 if cell.is_gold
    else
      cell.move_to_next_road
    end

    user_data.save
    cell.save

    e.destroy
    event_building_up.destroy
  end
end
