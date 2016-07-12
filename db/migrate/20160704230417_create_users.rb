class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :email
      t.string :password
      t.integer :user_type
      t.integer :castle_x
      t.integer :castle_y
      t.string :color
      t.timestamps null: false
    end
  end
end
