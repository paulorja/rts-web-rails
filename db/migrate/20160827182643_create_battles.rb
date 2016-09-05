class CreateBattles < ActiveRecord::Migration
  def change
    create_table :battles do |t|
      t.references :user_from
      t.references :user_to
      t.references :cell
      t.text :battle_data
      t.integer :step
      t.integer :total_steps

      t.timestamps null: false
    end
  end
end
