class CreateUserData < ActiveRecord::Migration
  def change
    create_table :user_data do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :wood
      t.integer :gold
      t.integer :storage
      t.string :last_update

      t.timestamps null: false
    end
  end
end
