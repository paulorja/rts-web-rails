class CreateMarketOffers < ActiveRecord::Migration
  def change
    create_table :market_offers do |t|
      t.references :user
      t.references :return_user
      t.string :offer_recourse
      t.string :return_recourse
      t.integer :offer_amount
      t.integer :return_amount
      t.integer :status
      t.integer :arrivet_at

      t.timestamps null: false
    end
  end
end
