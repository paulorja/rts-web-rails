class BattleController < ApplicationController


  def attack
    @armies = @current_user.all_armies
  end

  def send_attack
    render json: EventBattle.start_event(@current_user, params[:cell_id]).battle_data

  end
end
