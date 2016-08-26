class EventToGrass < ActiveRecord::Base
  belongs_to :event
  belongs_to :cell

  def self.resolve(e)

    event_to_grass = EventToGrass.where('event_id = ?', e.id).first
    cell = Cell.find(event_to_grass.cell_id)
    user_data = UserData.where('user_id = ?', event_to_grass.user_id).first

    cell.idle = true

    cell.user_id = event_to_grass.user_id
    cell.cell_units.update_all({cell_id: cell.next_road.id})
    cell.user_id = nil

    cell.terrain_code = TERRAIN[:grass][:code]
    cell.terrain_sprite = Terrain.color_to_sprite(TERRAIN[:grass][:color])


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
    return 'É preciso remover primeiro o edifício' if cell.building_code != 0
    return 'Este edifício possui dono' if cell.have_user
    return 'Você não possui recursos' unless user.user_data.have_recourses TO_GRASS[obj]
    return 'Sua fronteira não chega até aqui' unless cell.can_to_grass user.id
    idle_villager = user.idle_villager
    return 'Você não possui aldões disponíveis' if idle_villager.nil?


    idle_villager.update_attributes(cell_id: cell.id)
    cell.idle = false

    user.user_data.use_recourses TO_GRASS[obj]

    event = Event.new
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + TO_GRASS[obj][:time]
    event.event_type = :to_grass
    event.save

    EventToGrass.create({
      event_id: event.id,
      cell_id: cell.id,
      user_id: user.id
    })

    cell.save
    user.user_data.save
  end
end
