class CreateCells < ActiveRecord::Migration
  def change
    create_table :cells do |t|
      t.integer :x
      t.integer :y
      t.integer :terrain_code
      t.integer :building_code
    end
  end
end
