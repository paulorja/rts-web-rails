class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :user
      t.integer :report_type
      t.boolean :read

      t.timestamps null: false
    end
  end
end
