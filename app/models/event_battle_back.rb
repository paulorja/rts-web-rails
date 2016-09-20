class EventBattleBack < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User', foreign_key: :user_from_id
  belongs_to :battle
  belongs_to :event

  def self.start_event(battle)

    user_from_killed_units = Array.new
    battle.from_armies.each do |armies_code|
      (1..battle.from_armies[armies_code[0]]['deaths']).each do |death|
        battle.user_from_armies.each do |unit|
          if unit['unit'] == armies_code[0].to_i and unit['death'] != true
            battle.kill_unit(unit['id'], 'user_from_armies')
            user_from_killed_units << unit['id']
            break
          end
        end
      end
    end
    battle.user_from.user_data.total_pop -= user_from_killed_units.size
    battle.user_from.user_data.save


    user_to_killed_units = Array.new
    battle.to_armies.each do |armies_code|
      (1..battle.to_armies[armies_code[0]]['deaths']).each do |death|
        battle.user_to_armies.each do |unit|
          if unit['unit'] == armies_code[0].to_i and unit['death'] != true
            battle.kill_unit(unit['id'], 'user_to_armies')
            user_to_killed_units << unit['id']
            break
          end
        end
      end
    end
    battle.user_to.user_data.total_pop -= user_to_killed_units.size
    battle.user_to.user_data.save


    battle.save

    event = Event.new()
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + Battle::CELL_SPEED * battle.route_size
    event.event_type = :battle_back
    event.save

    EventBattleBack.create({
                           event_id: event.id,
                           user_from_id: battle.user_from_id,
                           battle_id: battle.id
                       })


  end

  def self.resolve(e)
    event_battle_back = EventBattleBack.where('event_id = ?', e.id).first
    battle = Battle.find_by_id(event_battle_back.battle_id)

    user_castle = Cell.where('x = ? and y = ?', battle.user_from.castle_x, battle.user_from.castle_y).first 
    next_road = user_castle.next_road

    next_road = 'INSERT INTO cell_units (cell_id, user_id, unit, hurt, idle, attack, name) VALUES'
    query_units_values = Array.new

    battle.user_from_armies.each do |u|
      query_units_values.push "(#{next_road.id}, #{u['user_id']}, #{u['unit']}, #{u['hurt']}, '#{true}', '#{(u['attack']+0.1)}', '#{u['name']}')"
    end

    query_units << query_units_values.join(', ')+';'

    conn = ActiveRecord::Base.connection
    conn.execute(query_terrains)

    e.destroy
    event_battle_back.destroy
  end
end
