class MarketController < ApplicationController
  def home
    set_x_y

    @my_offers = MarketOffer.includes(:user).where('user_id = ?', @current_user.id)
    @offers = MarketOffer.includes(:user).where('user_id != ? and status = 0', @current_user.id)
  end

  def create

    offer_recourse = params[:offer_radio]
    return_recourse = params[:return_radio]
    offer_amount = params[:offer_amount].to_i
    return_amount = params[:return_amount].to_i

    error = false
    error = 'Você não pode trocar 0 recursos' if offer_amount <= 0 or return_amount <= 0
    error = 'Selecione recursos diferentes!' if offer_recourse == return_recourse
    error = 'Engraçadinho!' unless offer_recourse == 'wood' or offer_recourse == 'gold' or offer_recourse == 'food' or offer_recourse == 'stone'
    error = 'Engraçadinho!' unless return_recourse == 'wood' or return_recourse == 'gold' or return_recourse == 'food' or return_recourse == 'stone'
    error = 'Você não tem recursos' unless @user_data.have_recourses({offer_recourse.to_sym => offer_amount})

    @user_data.use_recourses({offer_recourse.to_sym => offer_amount})

    if error.is_a? String
      flash[:alert] = error
    else
      MarketOffer.create({
                             user_id: @current_user.id,
                             offer_recourse: offer_recourse,
                             return_recourse: return_recourse,
                             offer_amount: offer_amount,
                             return_amount: return_amount,
                             status: 0
                         }
      )
    end

    redirect_to :back
  end

  def delete
    m_offer = MarketOffer.find(params[:id])

    if m_offer and @current_user.id == m_offer.user_id
      flash[:notice] = 'Oferta excluída'
      @user_data.give_recourses({m_offer.offer_recourse.to_sym => m_offer.offer_amount})
      m_offer.destroy
    end

    redirect_to :back
  end

  def accept_offer
    event = EventOfferBegin.start_event(params[:id], @current_user)

    flash[:notice] = event if event.is_a? String

    redirect_to :back
  end
end
