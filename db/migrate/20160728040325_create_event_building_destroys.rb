class CreateEventBuildingDestroys < ActiveRecord::Migration
  def change
    create_table :event_building_destroys do |t|
      t.references :event
      t.references :cell

    end
  end
end
