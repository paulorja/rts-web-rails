class EventNewUnit < ActiveRecord::Base
  belongs_to :cell
  belongs_to :user
  belongs_to :event

  def self.start_event(unit, cell, amount, current_user)
    building = Building.get_building(cell.building_code)
    unit = Unit.get_unit(unit)
    user_data = current_user.user_data
    last_cell_training = EventNewUnit.where('cell_id = ?', cell.id).order('id DESC').first

    return 'você só pode treinar um de cada vez' if amount != 1
    return 'você não pode treinar esta unidade' unless building[:units].include? unit[:code]
    return 'Você não possui recursos' unless user_data.have_recourses unit[:pricing]
    return 'Construa mais casas!' unless user_data.max_pop > user_data.total_pop

    user_data.use_recourses unit[:pricing]
    user_data.total_pop += 1
    user_data.save

    event = Event.new
    event.start_time = Time.now.to_i
    if last_cell_training.nil?
      event.end_time = Time.now.to_i + unit[:pricing][:time]
    else
      event.end_time = last_cell_training.event.end_time + unit[:pricing][:time]
    end
    event.event_type = :event_new_unit
    event.save

    EventNewUnit.create(event_id: event.id, cell_id: cell.id, user_id: current_user.id, unit: unit[:code])
  end


  def self.resolve(e)
    event_new_unit = EventNewUnit.includes(:cell, :user).where('event_id = ?', e.id).first
    next_road = event_new_unit.cell.next_road
    CellUnit.create(unit: event_new_unit.unit, cell_id: next_road.id, user_id: event_new_unit.user_id)

    e.destroy
    event_new_unit.destroy
  end

end
