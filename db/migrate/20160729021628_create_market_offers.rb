class CreateMarketOffers < ActiveRecord::Migration
  def change
    create_table :market_offers do |t|
      t.references :user
      t.string :offer_recourse
      t.string :return_recourse
      t.integer :offer_amount
      t.integer :return_amount
      t.integer :status

      t.timestamps null: false
    end
  end
end
