class CreateEventMarketOffer < ActiveRecord::Migration
  def change
    create_table :event_market_offers do |t|
      t.references :event
      t.references :market_offer

    end
  end
end
