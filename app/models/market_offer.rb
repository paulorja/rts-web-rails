class MarketOffer < ActiveRecord::Base
  belongs_to :user

  enum status: [:waiting,
                :going,
                :returning]
end
