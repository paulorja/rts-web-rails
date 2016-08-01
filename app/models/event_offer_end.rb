class EventOfferEnd < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  belongs_to :market_offer

  def self.resolve(event)

  end

end
