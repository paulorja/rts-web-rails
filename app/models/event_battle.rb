class EventBattle < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User', foreign_key: :user_from_id
  belongs_to :user_to, class_name: 'User', foreign_key: :user_to_id
  belongs_to :cell
  belongs_to :battle

  def self.start_event(user_from, cell_id)
    cell_to = Cell.find(cell_id)
    battle = Battle.new

    battle.user_from_id = user_from.id
    battle.user_to_id = cell_to.user_id
    battle.cell_to_id = cell_to.id

    return false unless battle.can_attack

    battle.battle_data = {
        user_from_armies: CellUnit.where('user_id = ? and unit != 1', battle.user_from_id),
        user_to_armies: CellUnit.where('user_id = ? and unit != 1', battle.user_to_id),
        cells: cell_to.arredores(1)
    }.to_json

    return battle
  end

  def self.resolve(e)
  end

end
