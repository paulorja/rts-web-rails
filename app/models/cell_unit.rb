class CellUnit < ActiveRecord::Base
  belongs_to :cell
  belongs_to :user

  def move(target_cell, user_data)
    if cell.user_id == target_cell.user_id and cell.idle and target_cell.idle
      if target_cell.is_recourse_building and target_cell.building_level > 0
        user_data.add_wood_villager target_cell
        user_data.add_gold_villager target_cell
        user_data.add_stone_villager target_cell
        user_data.add_farm_villager target_cell
      end
      if cell.is_recourse_building
        user_data.remove_wood_villager cell
        user_data.remove_gold_villager cell
        user_data.remove_stone_villager cell
        user_data.remove_farm_villager cell
      end

      update_attributes(cell_id: target_cell.id)
      user_data.save
    end
  end
end
