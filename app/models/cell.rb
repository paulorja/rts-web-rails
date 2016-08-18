class Cell < ActiveRecord::Base

  belongs_to :user
  has_one :event_building_up
  has_one :event_to_grass
  has_one :event_building_destroy
  has_many :cell_units


  def is_road
    true if building_code == BUILDING[:road][:code]
  end

  def is_castle
    true if building_code == BUILDING[:castle][:code]
  end

  def is_market
    true if building_code == BUILDING[:market][:code]
  end

  def is_blacksmith
    true if building_code == BUILDING[:blacksmith][:code]
  end

  def is_house
    true if building_code == BUILDING[:house][:code]
  end

  def is_storage
    true if building_code == BUILDING[:storage][:code]
  end

  def is_recourse_building
    true if is_lumberjack or is_gold_mine or is_stone_mine or is_farm
  end

  def is_lumberjack
    true if building_code == BUILDING[:lumberjack][:code]
  end

  def is_gold_mine
    true if building_code == BUILDING[:gold_mine][:code]
  end

  def is_stone_mine
    true if building_code == BUILDING[:stone_mine][:code]
  end

  def is_farm
    true if building_code == BUILDING[:farm][:code]
  end

  def have_building
    true if building_code != 0
  end

  def is_grass
    true if terrain_code == TERRAIN[:grass][:code]
  end

  def is_tree
    true if terrain_code == TERRAIN[:tree][:code]
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
    return true if building[:code] == BUILDING[:castle][:code] and building_level > 0
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

  def have_user
    true if user_id.to_i > 0
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

  def have_user_road_in_cells(user_id, cells)
    top_cell = top(cells)
    left_cell = left(cells)
    bottom_cell = bottom(cells)
    right_cell = right(cells)

    return true if top_cell.user_id == user_id and top_cell.is_road
    return true if left_cell.user_id == user_id and left_cell.is_road
    return true if bottom_cell.user_id == user_id and bottom_cell.is_road
    return true if right_cell.user_id == user_id and right_cell.is_road

    false
  end

  def self.point_distance(x1, y1, x2, y2)
    distance = Math.sqrt(((x2-x1)**2) + ((y2-y1)**2))

    '%.1f' % distance
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

  def self.move_unit(cell, target_cell, villager)
    villager.cell_id = target_cell.id
    villager.save
  end

  def next_road
    arredores = arredores(1)

    if arredores[1].is_road and arredores[1].user_id == self.user_id
      return arredores[1]
    elsif arredores[3].is_road and arredores[3].user_id == self.user_id
      return arredores[3]
    elsif arredores[5].is_road and arredores[5].user_id == self.user_id
      return arredores[5]
    elsif arredores[7].is_road and arredores[7].user_id == self.user_id
      return arredores[7]
    end
    nil
  end

  def move_units_to_next_road
    cell_units.update_all(cell_id: next_road.id)
  end

  def self.render_layers(cells, current_user)
    html  = ''
    sprites_layer_1 = ''
    sprites_layer_2 = ''
    sprites_layer_3 = ''

    cells.each do |cell|

      # TERRAINS

      sprites_layer_1 << "<div class='sprite #{Terrain.get_terrain(cell.terrain_code)[:css_class]}'></div>"

      # BUILDINGS

      building = Building.get_building(cell.building_code)
      villager_action = ''

      if building != nil
        if cell.user_id == current_user.id
          villager_action = "v-action='#{building[:action]}'" if building[:action]
        end
        sprites_layer_2 << "<div class='sprite #{building[:css_class]}-#{cell.building_level}'></div>"
      else
        if cell.have_user_road_in_cells(current_user.id, cells)
          sprites_layer_2 << "<div class='sprite sprite-can-build'></div>"
        else
          sprites_layer_2 << "<div class='sprite'></div>"
        end
      end

      # SPRITE SELECTION

      sprites_layer_3 << "<div class='link-sprite' obj_id='#{cell.id}' style='#{cell.border_style(cells)}' #{villager_action}>"

      sprites_layer_3 << "<div class='sprite-timer chronometer' data_time='#{cell.event_building_up.event.wait_time}'></div>" if cell.event_building_up
      sprites_layer_3 << "<div class='sprite-timer chronometer' data_time='#{cell.event_to_grass.event.wait_time}'></div>" if cell.event_to_grass
      sprites_layer_3 << "<div class='sprite-timer chronometer' data_time='#{cell.event_building_destroy.event.wait_time}'></div>" if cell.event_building_destroy

      if cell.villagers.is_a? String
        cell.villagers.split(';').each do  |v|
          sprites_layer_3 << "<div class='sprite-villager sprite-vil-#{v}' obj_id='#{v}'></div>"
        end
      end

      cell.cell_units.each do |u|
        unity = Unit.get_unit(u.unit)

        sprites_layer_3 << "<div class='sprite-villager sprite-vil-#{unity[:code]}' obj_id='#{u.id}'></div>"
      end

      if cell.is_recourse_building
        (0..cell.building_level-cell.cell_units.size-1).each do
          sprites_layer_3 << "<div class='sprite-unit-space'></div>"
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

  def build(user_data, current_user, building_code)
    building = Building.get_building(building_code.to_i)
    terrain = Terrain.get_terrain(terrain_code)

    return 'Já está evoluindo' unless idle?
    return 'Nível máximo atingido' if building[:levels][building_level+1].nil?
    return 'Você não possui recursos' unless user_data.have_recourses building[:levels][building_level+1]
    return "Requer castelo nível #{building[:levels][building_level+1][:castle_level].to_i}" unless current_user.castle.building_level >= building[:levels][building_level+1][:castle_level].to_i
    return 'Você não pode construir neste terreno' unless terrain_can_build(terrain, building)
    return 'Suas estradas não chegam até aqui' unless have_user_road current_user.id
    idle_villager = current_user.idle_villager
    return 'Você não possui aldões disponíveis' if idle_villager.nil?

    if building_code == BUILDING[:road][:code].to_s
      if user_data.max_roads > user_data.total_roads
        user_data.total_roads += 1
        user_data.save
      else
        return 'Limite de estradas atingido. Evolua o castelo. '
      end
    end

    #start build
    user_data.use_recourses building[:levels][building_level+1]

    event = Event.new
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + building[:levels][building_level+1][:time]
    event.event_type = :building_up
    event.save

    EventBuildingUp.create({cell_id: id, event_id: event.id})

    self.building_code = building_code
    self.user_id = current_user.id
    Cell.move_unit(idle_villager.cell, self, idle_villager)
    self.idle = false
    self.save

    require 'rmagick'
    img = Magick::Image.read('public/world.bmp')[0]
    img.pixel_color(x, y, current_user.color)
    img.write('public/world.bmp')

    true
  end

end
