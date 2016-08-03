class CreateEventOfferEnds < ActiveRecord::Migration
  def change
    create_table :event_offer_ends do |t|
      t.references :event
      t.references :user
      t.references :market_offer

    end
  end
end
