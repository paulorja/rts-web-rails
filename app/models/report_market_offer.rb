class ReportMarketOffer < ActiveRecord::Base
  belongs_to :report
  belongs_to :market_offer

end
