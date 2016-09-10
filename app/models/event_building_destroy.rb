class EventBuildingDestroy < ActiveRecord::Base
  belongs_to :event
  belongs_to :cell

  def self.resolve(e)
    event_building_destroy = EventBuildingDestroy.where('event_id = ?', e.id).first
    cell = Cell.find(event_building_destroy.cell_id)

    cell.destroy_building

    e.destroy
    event_building_destroy.destroy
  end

  def self.start_event(x, y, user)
    cell = Cell.where('x = ? and y = ?', x, y).first

    #validations
    return 'Você não pode destruir um edifício com unidades' if cell.cell_units.size > 0
    return 'Você não pode destruir esta estrada' unless cell.can_remove_road(user) and cell.is_road
    return 'Você não pode destruir seu castelo' if cell.is_castle
    return 'Este edifício não é seu' if cell.user_id != user.id
    return 'Suas estradas não chegam até aqui' unless cell.have_user_road user.id
    idle_villager = user.idle_villager
    return 'Você não possui aldões disponíveis' if idle_villager.nil?

    idle_villager.cell_id = cell.id

    cell.user_id = user.id
    cell.idle = false

    event = Event.new
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + (60*cell.building_level)
    event.event_type = :building_destroy
    event.save

    EventBuildingDestroy.create({
                            event_id: event.id,
                            cell_id: cell.id
                        })

    cell.save
    user.user_data.save
    idle_villager.save
  end
end
