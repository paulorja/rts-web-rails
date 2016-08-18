class CreateCellUnits < ActiveRecord::Migration
  def change
    create_table :cell_units do |t|
      t.references :cell
      t.references :user
      t.integer :unit
    end
  end
end
