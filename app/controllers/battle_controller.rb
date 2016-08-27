class BattleController < ApplicationController

  def attack
    render json: EventBattle.start_event(@current_user, params[:cell_id]).battle_data


  end
end
