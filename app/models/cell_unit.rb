class CellUnit < ActiveRecord::Base
  belongs_to :cell
  belongs_to :user

  def is_villager
    true if unit == UNIT[:villager][:code]
  end

  def move(target_cell)

    if target_cell.building_level == target_cell.cell_units.size and target_cell.is_recourse_building and target_cell.building_level > 0
      return "Apenas #{target_cell.building_level} podem coletar recursos aqui"
    end
    if cell.user_id != target_cell.user_id
      return "nao foi possível realizar seu movimento"
    end
    if !target_cell.idle or !cell.idle
      return "nao foi possível realizar seu movimento 2"
    end

    user_data = UserData.find_by_user_id(user_id)
    if is_villager
      if target_cell.is_recourse_building and target_cell.building_level > 0
        user_data.wood_villagers += 1 if target_cell.is_lumberjack
        user_data.stone_villagers += 1 if target_cell.is_stone_mine
        user_data.gold_villagers += 1 if target_cell.is_gold_mine
        user_data.food_villagers += 1 if target_cell.is_farm
      end
      if cell.is_recourse_building
        user_data.wood_villagers -= 1 if cell.is_lumberjack and user_data.wood_villagers > 0
        user_data.gold_villagers -= 1 if cell.is_gold_mine and user_data.gold_villagers > 0
        user_data.stone_villagers -= 1 if cell.is_stone_mine and user_data.stone_villagers > 0
        user_data.food_villagers -= 1 if cell.is_farm and user_data.food_villagers > 0
      end
    end

    self.cell_id = target_cell.id
    self.save
    user_data.save
  end

  def self.random_name
    first_names = ['Grendel', 'Siegfrield', 'Lofar', 'Alvis', 'Etiri', 'Brokk', 'Duirynn', 'Urd', 'Tyr', 'Njord', 'Erick', 'Bjorn', 'Foki', 'Gimle', 'Olaf', 'Elnar', 'Hakon', 'Herald', 'Knut', 'Ivar', 'Oleg', 'Svante', 'Siefrield', 'Ulf', 'Svein', 'Rurik', 'Vidar', 'Bera', 'Drifa', 'Idun', 'Liv', 'Kaira', 'Sigrid', 'Thyra', 'Unn', 'Cora', 'Corina', 'Agnes', 'Haurvatat', 'Jing', 'Kamal', 'Kamil', 'Wafl', 'Xue', 'Irfan', 'Amala', 'Bistra', 'Glenda', 'Kyioko', 'Punit', 'VImal', 'Rasul', 'Driscoll', 'Vesna', 'Gaia', 'Ceres', 'Enki', 'Jordi', 'Francesca', 'Helga', 'Sero', 'Othav', 'Emin', 'Enes', 'Néstor', 'Enzo', 'Enzer', 'Ilan', 'Bigin', 'Elyoht', 'Rolf', 'Siv', 'SOlveig', 'Álcis', 'Uriah', 'Ran', 'Reginn', 'Reno', 'Riesenheim', 'Rimer', 'Rimgrim', 'Rinda', 'Ring', 'Rossweise', 'Rowana', 'Rubezahl', 'Runas','Lada', 'Landvaettir', 'Landylfes', 'Laufey', 'LifLiftrasir', 'Loder', 'Lofn', 'Loki', 'Loptr', 'Eddas', 'Edimilton', 'Eggther', 'El', 'Einherjes', 'Elfos', 'Elli', 'Erda', 'Eostre', 'Ezudes']

    last_names  = ['Hughes', 'Wood', 'Griffiths', 'Lothbrok', 'Voorhees','Moretzsohn', 'Sarkissian', 'Malakian', 'Vardanian', 'Odadjian', 'Olsen', 'Kharring', 'Witzenben', 'March', 'Camaz', 'Sanders', 'Sebolt', 'Targen', 'Luckdgens', 'Seemensen', 'Albyer', 'Craigh', 'Heiden', 'Flauman', 'Xoritz']

    return "#{first_names.sample} #{last_names.sample}"
  end

  def self.all_user_armies(user_id)
    CellUnit.where('user_id = ? and unit != 1', user_id)
  end

  def self.user_have_idle_army(user_id)
    true if CellUnit.where('user_id = ? and unit != 1', user_id).first
  end
end
