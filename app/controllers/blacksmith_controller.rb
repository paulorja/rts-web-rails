class BlacksmithController < ApplicationController

  def home
    @event_blacksmith = EventBlacksmith.where('user_id = ?', @current_user.id).first
    @user_data.reload
  end

  def up_item
    event = EventBlacksmith.start_event(@current_user, params[:up_column])

    if event.is_a? String
      flash[:alert] = event
    end

    redirect_to :back
  end

end
