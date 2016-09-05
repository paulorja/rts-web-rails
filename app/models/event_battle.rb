class EventBattle < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User', foreign_key: :user_from_id
  belongs_to :user_to, class_name: 'User', foreign_key: :user_to_id
  belongs_to :cell
  belongs_to :battle
  belongs_to :event

  BATTLE_TIME = 3600
  MAX_SETPS = 6

  def self.start_event(user_from, cell_id, units, total_steps)
    total_steps = total_steps.to_i

    cell = Cell.find(cell_id)
    battle = Battle.new
    battle.user_from_id = user_from.id
    battle.user_to_id = cell.user_id
    battle.cell_id = cell.id
    battle.step = 1
    battle.total_steps = total_steps

    user_units = CellUnit.where('user_id = ? and id IN (?) and idle = true', user_from.id, units)

    return "Você não selecionou nenhum soldado" if user_units.size < 1
    return "Suas estradas não chegam no alvo" unless cell.have_user_road(user_from.id)
    return "Seu ligeiro" if total_steps < 1 or total_steps > MAX_SETPS

    battle.battle_data = {
        user_from_armies: user_units,
        cells: cell.arredores(1)
    }.to_json

    battle.save

    event = Event.new()
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + BATTLE_TIME
    event.event_type = :battle
    event.save

    EventBattle.create({
         event_id: event.id,
         user_from_id: battle.user_from_id,
         user_to_id: battle.user_to_id,
         cell_id: battle.cell_id,
         battle_id: battle.id
    })

    return battle
  end

  def self.resolve(e)
    event_battle = EventBattle.where('event_id = ?', e.id).first
    battle = Battle.find_by_id(event_battle.battle_id)

    battle.combat

    if battle.step >= battle.total_steps
      e.destroy
      event_battle.destroy
    else
      e.end_time += Time.now.to_i + BATTLE_TIME
      e.save
    end
  end

end
