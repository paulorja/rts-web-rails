class CellUnit < ActiveRecord::Base
  belongs_to :cell
  belongs_to :user

  def is_villager
    true if unit == UNIT[:villager][:code]
  end

  def move(target_cell)
    user_data = UserData.find_by_user_id(user_id)

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
    first_names = ['John', 'Will', 'Francis', 'Paul', 'Sarah', 'Louis', 'Louise', 'Marie', 'Joseph', 'Anna', 'Carl', 'Jacob', 'Elliot', 'May', 'Clarie', 'Gary', 'Ash', 'Carlton', 'Lisa', 'Robert', 'Jeff', 'Edgard', 'Edward', 'Billy', 'Balman', 'Dante', 'Dolson', 'Carter', 'Donald', 'Joan', 'Carrie', 'Alene', 'Daisy', 'Sophie', 'Briston', 'Bristol', 'Ashley', 'Bevery', 'Debbie', 'Elsie', 'Jaclyn', 'Sam', 'Emily', 'Isla', 'Grace', 'Annabelle', 'Erin', 'Leah', 'Lola', 'Eleanor', 'Amber', 'Rose', 'Alexandra', 'Scarlet', 'Katie', 'Rosie', 'Matilda', 'Clara', 'Willow', 'Elena', 'Daniel', 'Oliver', 'Joshua', 'Alfie', 'Noah', 'Nolan', 'Aidan', 'Sam', 'Finn', 'Jake', 'Samuel', 'Isaac', 'Henry', 'Max', 'Thomas', 'Tom', 'Don', 'Riley', 'Ian', 'Liam', 'Sebastian', 'Matthew', 'Nathan', 'Zac', 'Zed', 'Alex', 'Luke', 'Jamie', 'Aaron', 'Logan', 'Archie', 'Leo', 'Tyler', 'Ryan', 'Gabe', 'Gabriel', 'Jhonattan', 'Caleb', 'Dexter', 'Rory', 'Roy', 'Throy', 'Thor', 'Finley', 'Luca', 'Ben', 'Theo', 'Rhys', 'Finley', 'Liam', 'Seth', 'Sebastian', 'Matthew', ' Harry', 'Harryson',' Harrisson', 'Cameron', 'Jude', 'Leon', 'Blake', 'Hayden', 'Kyle', 'Reuben', 'Connor', 'Conor', 'Condor', 'Blanke', 'Blanch', 'Blake', 'Hugo', 'Samantha', 'Gustav', 'Gustavsen', 'Somebodylove' , 'Steel', 'Gold']

    last_names  = ['Clinton', 'Silva', 'da Silva', 'Mattos', 'Smith', 'Wilson', 'Hughes', 'Lewis', 'Wood', 'Turner', 'Sparrow', 'Jackson', 'Patel', 'Robinson', 'Jhonson', 'Bolt', 'Cooper', 'Torres', 'dos Santos', 'James da Costa Cunha', 'Parker', 'Young', 'Bennett', 'Price', 'Griffiths', 'Alcantara', 'Albuquerque', 'Mesquita', 'Souza', 'de Souza', 'Bernardes', '	Junior', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI', 'XII', 'XIII', 'XIV', 'XV', 'Neto', 'Ann', 'O Humano', 'O Cão', 'Phelps', 'Lotche', 'Lotch', 'Barbosa', 'Souza e Souza', 'Martins', 'Lothbrok', 'Biazi', 'Salgueiro', 'Kruger', 'Mendonça', 'Gomes', 'Filho', 'Coimbra', 'Machado', 'Phenix', 'Winkler', 'Leite', 'O Neil', 'Witson', 'Voorhees', 'Takashima', 'Yoshimura', '-kun']

    return "#{first_names.sample} #{last_names.sample}"
  end
end
