class EventBattleBack < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User', foreign_key: :user_from_id
  belongs_to :battle
  belongs_to :event

  def self.start_event(user_from, battle)

    killed_units = Array.new

    battle.from_armies.each do |armies_code|
      (1..battle.from_armies[armies_code[0]]['deaths']).each do |death|
        battle.user_from_armies.each do |unit|
          if unit['unit'] == armies_code[0].to_i and unit['death'] != true
            battle.kill_unit(unit['id'])
            killed_units << unit['id']
            break
          end
        end
      end
    end

    battle.save

    event = Event.new()
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + Battle::CELL_SPEED * battle.route_size
    event.event_type = :battle
    event.save

    EventBattleBack.create({
                           event_id: event.id,
                           user_from_id: battle.user_from_id,
                           battle_id: battle.id
                       })


  end

  def self.resolve_event(e)

  end
end
