class WorldController < ApplicationController
  include WorldHelper

  def world
  end

  def world_zoom
    set_x_y

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

    if @current_user.id == @cell.user_id
      Cell.move_villager(@cell, @target_cell, @villager)
    end

    redirect_to :back
  end


  def build
    x = params[:x]
    y = params[:y]
    building_code = params[:building_code]

    cell = Cell.where('x = ? and y = ?', x, y).first
    building = Building.get_building(building_code.to_i)
    terrain = Terrain.get_terrain(cell.terrain_code)

    recourses_ok = @user_data.have_recourses building[:levels][cell.building_level+1]
    terrain_ok = cell.terrain_can_build(terrain, building)
    road_ok = cell.have_user_road @current_user.id
    idle_villager = @user_data.idle_villager

    if road_ok and terrain_ok and recourses_ok and cell.building_code == 0 and idle_villager
      @user_data.use_recourses building[:levels][cell.building_level+1]

      event = Event.new()
      event.start_time = Time.now.to_i
      event.end_time = Time.now.to_i + building[:levels][1][:time]
      event.event_type = :building_up
      event.save

      EventBuildingUp.create({cell_id: cell.id, event_id: event.id})

      cell.building_code = building_code
      cell.user_id = @current_user.id
      cell.add_villager(idle_villager)
      cell.idle = false
      cell.save

      @user_data.remove_idle_villager

      update_world_pixel(x, y, @current_user.color)
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
