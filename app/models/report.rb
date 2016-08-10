class Report < ActiveRecord::Base
  belongs_to :user

  enum report_type: [
      :market_offer
  ]

end
