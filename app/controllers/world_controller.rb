class WorldController < ApplicationController
  def world
  end

  def world_zoom
    set_x_y

    @cells = Cell.world_zoom(@x, @y)



  end

  def world_detail
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
