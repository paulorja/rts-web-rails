class EventOfferBegin < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  belongs_to :market_offer

  def self.start_event(offer_id, current_user)

    offer = MarketOffer.find(offer_id)
    user_offer = offer.user

    return 'Você só pode trocar com um usuário diferente' if user_offer.id == current_user.id


    users_distance = User.user_distance(current_user, user_offer)

    event = Event.new
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + users_distance*10
    event.event_type = :offer_begin
    event.save

    EventOfferBegin.create({
        user_id: current_user.id,
        market_offer_id: offer.id,
        event_id: event.id
                           })
  end

  def self.resolve(event)

  end

end
