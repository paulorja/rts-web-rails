class MarketOffer < ActiveRecord::Base
  belongs_to :user
  belongs_to :return_user, class_name: 'User', foreign_key: :return_user_id
  belongs_to :event_market_offer

  def wait_time
    ((Time.now.to_i - self.arrivet_at) * -1).to_s
  end


  enum status: [:waiting,
                :going,
                :complete]
end
