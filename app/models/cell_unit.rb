class CellUnit < ActiveRecord::Base
  belongs_to :cell
  belongs_to :user

  def is_villager
    true if unit == UNIT[:villager][:code]
  end

  def move(target_cell, user_data)
    if cell.user_id == target_cell.user_id and cell.idle and target_cell.idle

      if is_villager
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
      end

      if !is_villager and target_cell.is_recourse_building

      else
        update_attributes(cell_id: target_cell.id)
        user_data.save
      end
    end
  end

  def self.random_name
    first_names = ['João', 'Alberto', 'Francisco', 'James', 'Johnny']
    last_names  = ['da Silva', 'Cunha', 'dos Santos', 'Santos']

    return "#{first_names.sample} #{last_names.sample}"
  end
end
