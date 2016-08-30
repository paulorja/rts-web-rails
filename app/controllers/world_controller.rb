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


    @cells = Cell.includes(:user, :cell_units,event_building_up: :event, event_building_destroy: :event, event_to_grass: :event).world_zoom(@x, @y)
  end

  def cell_actions
    set_x_y

    @cell = Cell.find(params[:cell_id])

    render file: 'world/cell_actions', layout: false
  end

  def unit
    @unit = CellUnit.find(params[:unit_id])
    render file: 'world/unit', layout: false
  end

  def move_unit
    target_cell = Cell.find(params[:target_cell_id])
    villager = CellUnit.find(params[:villager])

    move = villager.move(target_cell)

    if move.is_a? String
      flash['alert'] = move
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

  def new_unit
    event = EventNewUnit.start_event(params[:unit].to_i, Cell.find(params[:cell]), params[:amount].to_i, @current_user)
    if event.is_a? String
      flash['alert'] = event
    end

    redirect_to :back
  end

  def to_grass
    event = EventToGrass.start_event(params[:x], params[:y], @current_user)
    if event.is_a? String
      flash['alert'] = event
    end

    redirect_to :back
  end

  def building_destroy
    event = EventBuildingDestroy.start_event(params[:x], params[:y], @current_user)
    if event.is_a? String
      flash['alert'] = event
    end

    redirect_to :back
  end

end
