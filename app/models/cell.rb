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

  def have_villager(villager)
    villagers.split(';').each do |v|
      if v == villager.to_s
        return true
      end
    end
    false
  end

  def remove_villager(villager)
    new_array = villagers.split(';')

    villagers.split(';').each_with_index do |v, index|
      if v == villager
          new_array.delete_at(index)
        break
      end
    end

    if new_array.empty?
      self.villagers = nil
    else
      self.villagers = new_array.join(';')
    end
    self.save
  end

  def add_villager(villager)
    if villagers.nil?
      self.villagers = villager.to_s
    else
      self.villagers = villagers.split(';').append(villager).join(';')
    end

    self.save
  end

  def self.move_villager(cell, target_cell, villager)
    if cell.have_villager villager and cell.id != target_cell.id and cell.user_id == target_cell.user_id and cell.idle and target_cell.idle
      cell.remove_villager villager
      target_cell.add_villager villager
    end
  end

  def self.render_layers(cells, current_user)
    html  = ''
    sprites_layer_1 = ''
    sprites_layer_2 = ''
    sprites_layer_3 = ''

    cells.each do |cell|

      #TERRAINS

      sprites_layer_1 << "<div class='sprite #{Terrain.get_terrain(cell.terrain_code)[:css_class]}'></div>"

      #BUILDINGS

      building = Building.get_building(cell.building_code)
      villager_action = ""

      if building != nil
        if cell.user_id == current_user.id
          villager_action = "v-action='#{building[:action]}'" if building[:action]
        end
        sprites_layer_2 << "<div class='sprite #{building[:css_class]}-#{cell.building_level}'></div>"
      else
        sprites_layer_2 << "<div class='sprite'></div>"
      end

      #SPRITE SELECTION

      sprites_layer_3 << "<div class='link-sprite' obj_id='#{cell.id}' style='#{cell.border_style(cells)}' #{villager_action}>"
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
