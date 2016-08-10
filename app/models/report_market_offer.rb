class ReportMarketOffer < ActiveRecord::Base
  belongs_to :report
  belongs_to :market_offer

  enum report_type: [
      :user_accept_offer,
      :user_recourses_arrived
  ]

end
