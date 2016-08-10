class EventMarketOffer < ActiveRecord::Base
  belongs_to :event
  belongs_to :market_offer

  def self.start_event(offer_id, current_user)

    offer = MarketOffer.find(offer_id)
    user_offer = offer.user

    return 'Essa oferta já foi aceita' if offer.status != 'waiting'
    return 'Você só pode trocar com um usuário diferente' if user_offer.id == current_user.id
    return 'Você não possui recursos' unless current_user.user_data.have_recourses({offer.return_recourse.to_sym => offer.return_amount})

    current_user.user_data.use_recourses({offer.return_recourse.to_sym => offer.return_amount})

    users_distance = User.user_distance(current_user, user_offer)

    offer.return_user_id = current_user.id
    offer.status = 'going'
    offer.arrivet_at = Time.now.to_i + users_distance.to_i*10
    offer.save

    event = Event.new
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + users_distance.to_i*10
    event.event_type = :offer_begin
    event.save

    EventMarketOffer.create({
        market_offer_id: offer.id,
        event_id: event.id
                           })

  end

  def self.resolve(e)
    event_offer_begin = EventMarketOffer.includes(:market_offer).where('event_id = ?', e.id).first
    m_offer = event_offer_begin.market_offer

    m_offer.return_user.user_data.give_recourses({m_offer.offer_recourse.to_sym => m_offer.offer_amount})
    m_offer.user.user_data.give_recourses({m_offer.return_recourse.to_sym => m_offer.return_amount})

    m_offer.status = 'complete'
    m_offer.save

    report_user = Report.create({
      user_id: m_offer.user.id,
      user_2_id: m_offer.return_user.id,
      report_type: 1
    })
    report_return_user = Report.create({
       user_id: m_offer.return_user.id,
       user_2_id: m_offer.user.id,
       report_type: 1
     })

    ReportMarketOffer.create({
      report_id: report_user.id,
      market_offer_id: m_offer.id,
    })
    ReportMarketOffer.create({
      report_id: report_return_user.id,
      market_offer_id: m_offer.id,
    })

    e.destroy
    event_offer_begin.destroy
  end

end
