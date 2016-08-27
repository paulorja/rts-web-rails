class CreateReportBattles < ActiveRecord::Migration
  def change
    create_table :report_battles do |t|
      t.references :report
      t.references :battle

      t.timestamps null: false
    end
  end
end
