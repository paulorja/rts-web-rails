class CreateReportMarketOffers < ActiveRecord::Migration
  def change
    create_table :report_market_offers do |t|
      t.references :report
      t.references :market_offer

      t.timestamps null: false
    end
  end
end
