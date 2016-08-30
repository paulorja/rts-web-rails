class CreateEventNewUnits < ActiveRecord::Migration
  def change
    create_table :event_new_units do |t|
      t.references :event
      t.references :cell
      t.references :user
      t.integer :unit

    end
  end
end
