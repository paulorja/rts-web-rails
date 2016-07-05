class Cell < ActiveRecord::Base

  def self.world_zoom(x, y)
    x = x.to_i
    y = y.to_i

    range = 5

    min_x = x-range
    max_x = x+range-1
    min_y = y-range
    max_y = y+range-1

    Cell.where('x > ? and x < ? and y > ? and y < ?', min_x, max_x, min_y, max_y).order('y ASC, x ASC')


  end

end
