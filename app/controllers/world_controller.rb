class WorldController < ApplicationController
  include WorldHelper

  def world
  end

  def world_zoom
    set_x_y

    @x = '4' if @x.to_i < 4
    @y = '4' if @y.to_i < 4
    @x = '252' if @x.to_i > 252
    @y = '252' if @y.to_i > 252


    @cells = Cell.includes(:user, event_building_up: :event).world_zoom(@x, @y)

  end

  def cell_actions
    @cell = Cell.find(params[:cell_id])

    render file: 'world/cell_actions', layout: false
  end

  def villager
    @cell = Cell.find(params[:cell_id])
    @villager = params[:villager]
    render file: 'world/villager', layout: false
  end

  def villager_action
    @cell = Cell.find(params[:cell_id])
    @target_cell = Cell.find(params[:target_cell_id])
    @villager = params[:villager]


    if @target_cell.is_recourse_building and @target_cell.villager_number != 0
      flash['alert'] = 'Apenas 1 aldeão pode coletar recursos!'
    elsif @current_user.id == @cell.user_id

      if Cell.move_villager(@cell, @target_cell, @villager)
        if @target_cell.is_recourse_building
          @user_data.add_wood_villager @target_cell
          @user_data.add_gold_villager @target_cell
          @user_data.add_stone_villager @target_cell
          @user_data.add_farm_villager @target_cell
        end
        if @cell.is_recourse_building
          @user_data.remove_wood_villager @cell
          @user_data.remove_gold_villager @cell
          @user_data.remove_stone_villager @cell
          @user_data.remove_farm_villager @cell
        end
        @user_data.save
      end

    end

    redirect_to :back
  end

  def build
    x = params[:x]
    y = params[:y]
    building_code = params[:building_code]

    build = Cell.where('x = ? and y = ?', x, y).first.build(@user_data, @current_user, building_code)

    if build.is_a? String
      flash['alert'] = build
    end

    redirect_to :back
  end

  def new_villager
    new_villager = @user_data.new_villager @current_user

    if new_villager.is_a? String
      flash['alert'] = new_villager
    end

    redirect_to :back
  end

  private
    def set_x_y
      if params[:x]
        @x = params[:x]
      else
        @x = 0
      end

      if params[:x]
        @y = params[:y]
      else
        @y = 0
      end
    end
end
