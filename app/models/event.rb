class Event < ActiveRecord::Base

  enum event_type: [:building_up,
                    :to_grass,
                    :building_destroy,
                    :offer_begin,
                    :offer_end,
                    :blacksmith,
                    :event_new_unit,
                    :battle,
                    :battle_back]


  def wait_time
    ((Time.now.to_i - end_time) * -1).to_s
  end

  def self.resolve_events
    events = Event.where('end_time < ?', Time.now.to_i).order('end_time ASC')
    events.each do |e|

      case e.event_type
        when 'building_up'
          EventBuildingUp.resolve e
        when 'to_grass'
          EventToGrass.resolve e
        when 'building_destroy'
          EventBuildingDestroy.resolve e
        when 'offer_begin'
          EventMarketOffer.resolve e
        when 'blacksmith'
          EventBlacksmith.resolve e
        when 'event_new_unit'
          EventNewUnit.resolve e
        when 'battle'
          EventBattle.resolve e
        when 'battle_back'
          EventBattleBack.resolve e
        else
          raise 'Fodeo'
      end
    end
  end

end
