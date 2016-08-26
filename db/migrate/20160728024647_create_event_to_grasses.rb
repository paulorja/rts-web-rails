class CreateEventToGrasses < ActiveRecord::Migration
  def change
    create_table :event_to_grasses do |t|
      t.references :event
      t.references :cell
      t.references :user

    end
  end
end
