class BattleController < ApplicationController


  def attack
    @cell = Cell.find_by_id(params[:cell_id])
    @armies = @current_user.all_armies
    @attack_route = WorldMap.attack_route(@current_user, @cell)
    @route_img = WorldMap.route_to_img(@attack_route)

    unless @route_img.nil?
      @route_img_base64 = Base64.encode64(@route_img.to_blob).gsub(/\n/, "")
    end

    teste = 5
  end

  def send_attack
    start_battle = EventBattle.start_event(@current_user, params[:cell_id], params[:unit])

    if start_battle.is_a? String
      flash[:alert] = start_battle
      redirect_to :back
    else
      render json: start_battle.battle_data
    end
  end

end
