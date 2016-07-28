class EventToGrass < ActiveRecord::Base
  belongs_to :event
  belongs_to :cell

  def self.resolve(e)

    event_to_grass = EventToGrass.where('event_id = ?', e.id).first
    cell = Cell.find(event_to_grass.cell_id)
    user_data = UserData.where('user_id = ?', cell.user_id).first

    cell.terrain_code = TERRAIN[:grass][:code]
    cell.move_to_next_road
    cell.user_id = nil
    cell.idle = true

    user_data.idle_villagers += 1


    cell.save
    user_data.save

    e.destroy
    event_to_grass.destroy
  end

  def self.start_event(x, y, user)
    cell = Cell.where('x = ? and y = ?', x, y).first

    case cell.terrain_code
      when TERRAIN[:tree][:code]
        obj = :tree
      when TERRAIN[:stone][:code]
        obj = :stone
      when TERRAIN[:gold][:code]
        obj = :gold
      else
        return 'Objeto não encontrado'
    end

    #validations
    return 'Você não possui recursos' unless user.user_data.have_recourses TO_GRASS[obj]
    return 'Suas estradas não chegam até aqui' unless cell.have_user_road user.id
    idle_villager = user.user_data.idle_villager
    return 'Você não possui aldões disponíveis' if idle_villager.nil?


    cell.add_villager(idle_villager)
    cell.user_id = user.id
    cell.idle = false

    user.user_data.use_recourses TO_GRASS[obj]
    user.user_data.remove_idle_villager

    event = Event.new
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + TO_GRASS[obj][:time]
    event.event_type = :to_grass
    event.save

    EventToGrass.create({
      event_id: event.id,
      cell_id: cell.id
    })

    cell.save
    user.user_data.save
  end
end
