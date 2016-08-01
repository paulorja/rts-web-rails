class EventOfferBegin < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  belongs_to :market_offer

  def self.start_event(offer_id, current_user)

  end

  def self.resolve(event)

  end

end
