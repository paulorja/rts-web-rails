class CreateUserMessages < ActiveRecord::Migration
  def change
    create_table :user_messages do |t|
      t.string :title
      t.text :body
      t.references :from_user
      t.references :to_user
      t.boolean :read

      t.timestamps null: false
    end
  end
end
