class EventBuildingUp < ActiveRecord::Base
  belongs_to :event
  belongs_to :cell

  def self.resolve(e)
    event_building_up = EventBuildingUp.where('event_id = ?', e.id).first
    cell = Cell.find(event_building_up.cell_id)

    cell.building_level = cell.building_level + 1

    cell.save

    e.destroy
    event_building_up.destroy
  end
end
