class EventOfferBegin < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  belongs_to :market_offer

  def self.start_event(offer_id, current_user)

    offer = MarketOffer.find(offer_id)
    user_offer = offer.user

    return 'Essa oferta já foi aceita' if offer.status != 'waiting'
    return 'Você só pode trocar com um usuário diferente' if user_offer.id == current_user.id
    return 'Você não possui recursos' unless current_user.user_data.have_recourses({offer.return_recourse.to_sym => offer.return_amount})

    current_user.user_data.use_recourses({offer.return_recourse.to_sym => offer.return_amount})

    users_distance = User.user_distance(current_user, user_offer)

    offer.status = 'going'
    offer.save

    event = Event.new
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + users_distance.to_i*10
    event.event_type = :offer_begin
    event.save

    EventOfferBegin.create({
        user_id: current_user.id,
        market_offer_id: offer.id,
        event_id: event.id
                           })
  end

  def self.resolve(e)
    event_offer_begin = EventOfferBegin.includes(:market_offer).where('event_id = ?', e.id).first
    user_data = UserData.where('user_id = ?', event_offer_begin.user_id).first
    m_offer = event_offer_begin.market_offer

    user_data.give_recourses({m_offer.offer_recourse.to_sym => m_offer.offer_amount})
    m_offer.user.user_data.give_recourses({m_offer.return_recourse.to_sym => m_offer.return_amount})

    user_data.save

    e.destroy
    event_offer_begin.destroy
  end

end
