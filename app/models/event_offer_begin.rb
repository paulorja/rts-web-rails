class EventOfferBegin < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  belongs_to :market_offer

  def self.start_event(offer_id, current_user)
    offer = MarketOffer.find(offer_id)

    event = Event.new
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + 1000
    event.event_type = :offer_begin
    event.save

    EventOfferBegin.create({
        user_id: current_user.id,
        offer_id: offer.id,
        event_id: event.id
                           })
  end

  def self.resolve(event)

  end

end
