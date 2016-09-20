class EventBattle < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User', foreign_key: :user_from_id
  belongs_to :user_to, class_name: 'User', foreign_key: :user_to_id
  belongs_to :cell
  belongs_to :battle
  belongs_to :event

  def self.start_event(user_from, cell_id, units)

    cell = Cell.find(cell_id)
    battle = Battle.new
    battle.user_from_id = user_from.id
    battle.user_to_id = cell.user_id
    battle.cell_id = cell.id
    attack_route = WorldMap.attack_route(user_from, cell)
    battle.route_size = attack_route.size

    user_units = CellUnit.where('user_id = ? and id IN (?) and idle = true', user_from.id, units)

    return "Você não selecionou nenhum soldado" if user_units.size < 1
    return "Seus soldados não conseguem chegar no alvo" if attack_route.nil?

    battle.battle_data = {
        user_from_armies: user_units,
        cells: cell.arredores(1)
    }.to_json

    battle.save

    event = Event.new()
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + Battle::CELL_SPEED * attack_route.size
    event.event_type = :battle
    event.save

    EventBattle.create({
         event_id: event.id,
         user_from_id: battle.user_from_id,
         user_to_id: battle.user_to_id,
         cell_id: battle.cell_id,
         battle_id: battle.id
    })
    CellUnit.where('user_id = ? and id IN (?) and idle = true', user_from.id, units).delete_all

    return battle
  end

  def self.resolve(e)
    event_battle = EventBattle.where('event_id = ?', e.id).first
    battle = Battle.find_by_id(event_battle.battle_id)

    battle.combat

    EventBattleBack.start_event(@current_user, battle)

    e.destroy
    event_battle.destroy
  end

end
