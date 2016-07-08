class WorldController < ApplicationController
  include WorldHelper

  def world
  end

  def world_zoom
    set_x_y

    @cells = Cell.world_zoom(@x, @y)
  end

  def cell_actions
    @cell = Cell.find(params[:cell_id])

    render file: 'world/cell_actions', layout: false
  end

  def build
    x = params[:x]
    y = params[:y]
    building_code = params[:building_code]

    cell = Cell.where('x = ? and y = ?', x, y).first

    event = Event.new()
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + 5
    event.event_type = :building_up
    event.save

    EventBuildingUp.create({cell_id: cell.id, event_id: event.id})

    cell.update_attributes({building_code: building_code, user_id: current_user.id})

    update_world_pixel(x, y, current_user.color)


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
