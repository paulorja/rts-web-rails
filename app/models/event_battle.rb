class EventBattle < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User', foreign_key: :user_from_id
  belongs_to :user_to, class_name: 'User', foreign_key: :user_to_id
  belongs_to :cell
  belongs_to :battle

  def self.start_event(user_from, cell_id)
    cell = Cell.find(cell_id)
    battle = Battle.new
    battle.user_from_id = user_from.id
    battle.user_to_id = cell.user_id
    battle.cell_id = cell.id

    return "Suas estradas não chegam no alvo" unless cell_to.have_user_road(user_from_id)
    return "Você não tem tropas" if CellUnit.user_have_idle_army(user_from_id).nil?


    battle.battle_data = {
        user_from_armies: CellUnit.where('user_id = ? and unit != 1', battle.user_from_id),
        user_to_armies: CellUnit.where('user_id = ? and unit != 1', battle.user_to_id),
        cells: cell_to.arredores(1)
    }.to_json

    event = Event.new()
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + 3600
    event.event_type = :battle
    event.save

    EventBlacksmith.create({
         event_id: event.id,
         user_from_id: battle.user_from_id,
         user_to_id: battle.user_to_id,
         cell_id: battle.cell_id,
         battle_id: battle.id
    })

    return battle
  end

  def self.resolve(e)
  end

end
