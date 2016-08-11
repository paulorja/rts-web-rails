class CreateUserData < ActiveRecord::Migration
  def change
    create_table :user_data do |t|
      t.references :user, index: true, foreign_key: true
      t.float :wood, default: 0
      t.float :gold, default: 0
      t.float :food, default: 0
      t.float :stone, default: 0
      t.integer :wood_villagers, default: 0
      t.integer :gold_villagers, default: 0
      t.integer :food_villagers, default: 0
      t.integer :stone_villagers, default: 0
      t.integer :storage, default: 0
      t.integer :total_roads, default: 0
      t.integer :max_roads, default: 0
      t.integer :idle_villagers, default: 0
      t.integer :total_villagers, default: 0
      t.integer :max_villagers, default: 0
      t.integer :total_territories, default: 0
      t.integer :score, default: 0
      t.integer :new_reports, default: 0
      t.string :last_update

      t.timestamps null: false
    end
  end
end
