class Cell < ActiveRecord::Base

  belongs_to :user
  has_one :event_building_up


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
      return true if b == building[:code]
    end

    false
  end

  def top(cells)
    cells.each do |c|
      return c if c.x == x and c.y == y-1
    end
    Cell.new
  end

  def left(cells)
    cells.each do |c|
      return c if c.x == x-1 and c.y == y
    end
    Cell.new
  end

  def bottom(cells)
    cells.each do |c|
      return c if c.x == x and c.y == y+1
    end
    Cell.new
  end

  def right(cells)
    cells.each do |c|
      return c if c.x == x+1 and c.y == y
    end
    Cell.new
  end

  def border_style(cells)
    border_style = ''

    unless user.nil?
      #cells.each do |c|
      #  border_style << "border-top-color: #{user.color};"    if c.x == x and c.y == y-1 and c.user_id != user.id
      #  border_style << "border-bottom-color: #{user.color};" if c.x == x and c.y == y+1 and c.user_id != user.id
      #  border_style << "border-left-color: #{user.color};"   if c.x == x+1 and c.y == y and c.user_id != user.id
      #  border_style << "border-right-color: #{user.color};"  if c.x == x-1 and c.y == y and c.user_id != user.id
      #end

      border_style << "border-top-color: #{user.color};" unless top(cells).user_id == user.id
      border_style << "border-left-color: #{user.color};" unless left(cells).user_id == user.id
      border_style << "border-bottom-color: #{user.color};" unless bottom(cells).user_id == user.id
      border_style << "border-right-color: #{user.color};" unless right(cells).user_id == user.id
    end

    border_style
  end

  def have_user_road(user_id)
    arredores = arredores(1)

    return true if arredores[1].is_road and arredores[1].user_id == user_id
    return true if arredores[3].is_road and arredores[3].user_id == user_id
    return true if arredores[5].is_road and arredores[5].user_id == user_id
    return true if arredores[7].is_road and arredores[7].user_id == user_id

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

  def self.render_layers(cells)
    html  = ''
    sprites_layer_1 = ''
    sprites_layer_2 = ''
    sprites_layer_3 = ''

    cells.each do |cell|

      #TERRAINS

      sprites_layer_1 << "<div class='sprite #{Terrain.get_terrain(cell.terrain_code)[:css_class]}'></div>"

      #BUILDINGS

      building = Building.get_building(cell.building_code)
      if building != nil
        sprites_layer_2 << "<div class='sprite #{building[:css_class]}-#{cell.building_level}'></div>"
      else
        sprites_layer_2 << "<div class='sprite'></div>"
      end

      #SPRITE SELECTION

      sprites_layer_3 << "<div class='link-sprite' obj_id='#{cell.id}' style='#{cell.border_style(cells)}'>"
      if cell.event_building_up
        sprites_layer_3 << "<div class='sprite-timer' data_time='#{cell.event_building_up.event.wait_time}'></div>"
      end
      if cell.villagers.is_a? String
        cell.villagers.split(';').each do  |v|
          sprites_layer_3 << "<div class='sprite-villager sprite-vil-#{v}' obj_id='#{v}'></div>"
        end
      end
      sprites_layer_3 << "</div>"

    end



    def self.new_layer(layer)
      "<div class='cell_layer'>#{layer}</div>"
    end

    html << new_layer(sprites_layer_1)
    html << new_layer(sprites_layer_2)
    html << new_layer(sprites_layer_3)


    html.html_safe
  end

end
