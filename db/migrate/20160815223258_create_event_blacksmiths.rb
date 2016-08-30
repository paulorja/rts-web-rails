class CreateEventBlacksmiths < ActiveRecord::Migration
  def change
    create_table :event_blacksmiths do |t|
      t.references :event
      t.references :user
      t.string :up_column

    end
  end
end
