class CreateEventBattles < ActiveRecord::Migration
  def change
    create_table :event_battles do |t|
      t.references :user_from
      t.references :user_to
      t.references :cell
      t.references :battle

    end
  end
end
