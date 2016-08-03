class CreateEventOfferBegins < ActiveRecord::Migration
  def change
    create_table :event_offer_begins do |t|
      t.references :event
      t.references :user
      t.references :market_offer

    end
  end
end
