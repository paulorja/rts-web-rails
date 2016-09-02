class CreateCellUnits < ActiveRecord::Migration
  def change
    create_table :cell_units do |t|
      t.references :cell
      t.references :user
      t.integer :unit
      t.boolean :hurt, default: false
      t.boolean :idle, default: true
      t.float :attack, default: 0
      t.string :name
    end
  end
end
