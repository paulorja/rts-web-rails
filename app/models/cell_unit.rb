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
    first_names = ['John', 'Will', 'Francis', 'Paul', 'Sarah', 'Louis', 'Louise', 'Marie', 'Joseph', 'Anna', 'Carl', 'Jacob', 'Elliot', 'May', 'Clarie', 'Gary', 'Ash', 'Carlton', 'Lisa', 'Robert', 'Jeff', 'Edgard', 'Edward', 'Billy', 'Balman', 'Dante', 'Dolson', 'Carter', 'Donald', 'Joan', 'Carrie', 'Alene', 'Daisy', 'Sophie', 'Briston', 'Bristol', 'Ashley', 'Bevery', 'Debbie', 'Elsie', 'Jaclyn', 'Sam', 'Emily', 'Isla', 'Grace', 'Annabelle', 'Erin', 'Leah', 'Lola', 'Eleanor', 'Amber', 'Rose', 'Alexandra', 'Scarlet', 'Katie', 'Rosie', 'Matilda', 'Clara', 'Willow', 'Elena', 'Daniel', 'Oliver', 'Joshua', 'Alfie', 'Noah', 'Nolan', 'Aidan', 'Sam', 'Finn', 'Jake', 'Samuel', 'Isaac', 'Henry', 'Max', 'Thomas', 'Tom', 'Don', 'Riley', 'Ian', 'Liam', 'Sebastian', 'Matthew', 'Nathan', 'Zac', 'Zed', 'Alex', 'Luke', 'Jamie', 'Aaron', 'Logan', 'Archie', 'Leo', 'Tyler', 'Ryan', 'Gabe', 'Gabriel', 'Jhonattan', 'Caleb', 'Dexter', 'Rory', 'Roy', 'Throy', 'Thor', 'Finley', 'Luca', 'Ben', 'Theo', 'Rhys', 'Finley', 'Liam', 'Seth', 'Sebastian', 'Matthew', ' Harry', 'Harryson',' Harrisson', 'Cameron', 'Jude', 'Leon', 'Blake', 'Hayden', 'Kyle', 'Reuben', 'Connor', 'Conor', 'Condor', 'Blanke', 'Blanch', 'Blake', 'Hugo', 'Samantha', 'Gustav', 'Gustavsen', 'Somebodylove' , 'Steel', 'Gold']

    last_names  = ['Clinton', 'Silva', 'da Silva', 'Mattos', 'Smith', 'Wilson', 'Hughes', 'Lewis', 'Wood', 'Turner', 'Sparrow', 'Jackson', 'Patel', 'Robinson', 'Jhonson', 'Bolt', 'Cooper', 'Torres', 'dos Santos', 'James da Costa Cunha', 'Parker', 'Young', 'Bennett', 'Price', 'Griffiths', 'Alcantara', 'Albuquerque', 'Mesquita', 'Souza', 'de Souza', 'Bernardes', '	Junior', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI', 'XII', 'XIII', 'XIV', 'XV', 'Neto', 'Ann', 'O Humano', 'O Cão', 'Phelps', 'Lotche', 'Lotch', 'Barbosa', 'Souza e Souza', 'Martins', 'Lothbrok', 'Biazi', 'Salgueiro', 'Kruger', 'Mendonça', 'Gomes', 'Filho', 'Coimbra', 'Machado', 'Phenix', 'Winkler', 'Leite', 'O Neil', 'Witson', 'Voorhees', 'Takashima', 'Yoshimura', '-kun']

    return "#{first_names.sample} #{last_names.sample}"
  end

  def self.all_user_armies(user_id)
    CellUnit.where('user_id = ? and unit != 1', user_id)
  end

  def self.user_have_idle_army(user_id)
    true if CellUnit.where('user_id = ? and unit != 1', user_id).first
  end
end
