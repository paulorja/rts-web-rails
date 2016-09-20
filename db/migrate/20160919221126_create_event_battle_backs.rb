class CreateEventBattleBacks < ActiveRecord::Migration
  def change
    create_table :event_battle_backs do |t|
      t.references :event
      t.references :user_from
      t.references :battle

    end
  end
end
