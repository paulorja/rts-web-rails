class Cell < ActiveRecord::Base

  belongs_to :user


  def is_road
    true if building_code == BUILDING[:road][:code]
  end

  def have_building
    true if building_code != 0
  end

  def is_grass
    true if terrain_code == TERRAIN[:grass][:code]
  end

  def is_gold
    true if terrain_code == TERRAIN[:gold][:code]
  end

  def is_stone
    true if terrain_code == TERRAIN[:stone][:code]
  end

  def is_diamond
    true if terrain_code == TERRAIN[:diamond][:code]
  end

  def arredores(range)
    Cell.where('x >= ? and y >= ? and x <= ? and y <= ?', x-range, y-range, x+range, y+range).order('y ASC, x ASC')
  end

  def terrain_can_build(terrain, building)
    terrain[:buildings].each do |b|
      true if b == building[:code]
    end

    false
  end

  def have_user_road(user_id)
    arredores = arredores(1)

    true if arredores[1].is_road and arredores[1].user_id == user_id
    true if arredores[3].is_road and arredores[3].user_id == user_id
    true if arredores[5].is_road and arredores[5].user_id == user_id
    true if arredores[7].is_road and arredores[7].user_id == user_id

    false
  end

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
