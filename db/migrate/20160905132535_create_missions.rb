class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|

      t.timestamps null: false
    end
  end
end
