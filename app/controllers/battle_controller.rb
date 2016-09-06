class BattleController < ApplicationController


  def attack
    funcao_em_construcao
    redirect_to :back
    return

    @armies = @current_user.all_armies
  end

  def send_attack
    funcao_em_construcao
    redirect_to :back
    return
    
    start_battle = EventBattle.start_event(@current_user, params[:cell_id], params[:unit], params[:total_steps])

    if start_battle.is_a? String
      flash[:alert] = start_battle
      redirect_to :back
    else
      render json: start_battle.battle_data
    end
  end

  private
    def funcao_em_construcao
      flash[:alert] = 'As batalhas ainda não estão disponíveis.'
      return
    end

end
