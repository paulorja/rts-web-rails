class UserData < ActiveRecord::Base
  belongs_to :user

  def use_recourses(item)
    item_wood = item[:wood].to_i
    item_stone = item[:stone].to_i
    item_gold = item[:gold].to_i
    item_food = item[:food].to_i

    if wood >= item_wood and stone >= item_stone and gold >= item_gold and food >= item_food
      self.wood -= item_wood
      self.stone -= item_stone
      self.gold -= item_gold
      self.food -= item_food

      self.save
    end
  end

  def have_recourses(item)
    item_wood = item[:wood].to_i
    item_stone = item[:stone].to_i
    item_gold = item[:gold].to_i
    item_food = item[:food].to_i

    if wood >= item_wood and stone >= item_stone and gold >= item_gold and food >= item_food
      true
    else
      false
    end
  end

  def idle_villager
    begin
      return Cell.where('idle = ? and villagers IS NOT NULL and user_id = ?', true, user_id).first.villagers.split(';')[0]
    rescue
      return nil
    end
  end

  def remove_idle_villager
    self.idle_villagers = idle_villagers-1
    self.save

    cell = Cell.where('idle = ? and villagers IS NOT NULL and user_id = ?', true, user_id).first
    new_array = cell.villagers.split(';')
    new_array.delete_at(0)

    if new_array.empty?
      cell.villagers = nil
    else
      cell.villagers = new_array.join(';')
    end
    cell.save
  end

  def new_villager(user)
    #validate
    return 'Vocẽ não possui comida' if food < 100
    return 'Construa mais casas' if total_villagers == max_villagers

    #add villager
    castle = Cell.where('x = ? and y = ?', user.castle_x, user.castle_y).first
    castle.add_villager('1')

    self.food -= 100
    self.total_villagers += 1
    self.idle_villagers += 1
    self.save
    true
  end

  def self.start_user_data(user_id)
    UserData.create(
      user_id: user_id,
      wood: 1200,
      stone: 500,
      gold: 350,
      food: 350,
      storage: 2000,
      idle_villagers: 2,
      total_villagers: 2,
      total_territories: 4,
      max_villagers: 2,
      total_roads: 3,
      max_roads: BUILDING[:castle][:levels][1][:roads]
    )
  end

end
