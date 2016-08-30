class CreateEventBuildingUps < ActiveRecord::Migration
  def change
    create_table :event_building_ups do |t|
      t.references :event
      t.references :cell

    end
  end
end
