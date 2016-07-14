class CreateCells < ActiveRecord::Migration
  def change
    create_table :cells do |t|
      t.integer :x
      t.integer :y
      t.integer :terrain_code, default: 0
      t.integer :building_code, default: 0
      t.integer :building_level, default: 0
      t.integer :user_id, default: 0
      t.string :villagers
      t.boolean :idle, default: true
    end
  end
end
