class Cell < ActiveRecord::Base

  belongs_to :user
  has_one :event_building_up
  has_one :event_to_grass
  has_one :event_building_destroy
  has_one :event_battle
  has_many :cell_units


  def is_road
    true if building_code == BUILDING[:road][:code]
  end

  def is_bridge
    true if building_code == BUILDING[:road][:code] and is_water
  end

  def is_castle
    true if building_code == BUILDING[:castle][:code]
  end

  def is_wall
    true if building_code == BUILDING[:wall][:code]
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

  def is_water
    true if terrain_code == TERRAIN[:water][:code]
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

  def castle_come_here(user)
    require './lib/a_star'

    roads = Cell.where('user_id = ? and building_code = ?', user.id, BUILDING[:road][:code]).pluck(:x,  :y)

    map_creator = ""
    (0..256).each do |x|
      (0..256).each do |y|
        if user.castle_x == x and user.castle_y == y
          map_creator << "@"
        elsif self.x == x and self.y == y
          map_creator << "X"
        elsif roads.include? [x, y]
          map_creator << "."
        else
          map_creator << "~"
        end
      end
      map_creator << "\n"
    end

    map = Map.new map_creator

    begin
      map.find_route
      return true
    rescue
      return false
    end
  end

  def new_can_remove_road(user)
    require './lib/pathfinding_map'
    require 'set'

    logger.info "#{Time.now.to_f} START CAN REMOVE ROAD"

    # VALIDA SE TODAS AS CONSTRUCOES AO REDOR POSSUEM OUTRA ESTRADA
    roads_arredores = []
    arredores = arredores(1)
    roads_arredores << arredores[1] if arredores[1].is_road
    roads_arredores << arredores[3] if arredores[3].is_road
    roads_arredores << arredores[5] if arredores[5].is_road
    roads_arredores << arredores[7] if arredores[7].is_road

    construcoes_ao_redor = []
    arredores.each do |c|
      if c.user_id == user.id and !c.is_road and c.id != self.id
        construcoes_ao_redor << c
      end
    end

    estradas_encontradas = 0

    construcoes_ao_redor.each do |c|
      c_arredores = c.arredores(1)
      c_arredores.each do |c_a|
        if c_a.is_road and c_a.id != self.id
          estradas_encontradas += 1
          break
        end
      end
    end

    # PATHFINDING
    logger.info "#{Time.now.to_f} Start path finding to remove road"

    user_roads = Cell.where('user_id = ? and building_code = ? and idle = true', user.id, BUILDING[:road][:code]).pluck(:x,  :y)

    blocked_cells = Set.new 
    (0..256).each do |x|
      (0..256).each do |y|
        blocked_cells << [x, y] if (!user_roads.include? [x, y]) or (x == self.x and y == self.y) or (x != user.castle_x and y != user.castle_y)
      end
    end    
    logger.info "#{Time.now.to_f} Created blocked cells"

    map = PathfindingMap.new(blocked_cells)
    logger.info "#{Time.now.to_f} Created map"

    roads_arredores.each_with_index do |r, i|
      road_route = map.find_path(user.castle_x, user.castle_y, r.x, r.y)
      logger.info "#{Time.now.to_f} Route #{i} find"
      find = false if road_route.nil?
    end

    logger.info "#{Time.now.to_f} End path finding to remove road"

    if find and estradas_encontradas == construcoes_ao_redor.size
      true
    else
      false
    end

  end

  def can_remove_road(user)
    logger.info "#{Time.now.to_f} START CAN REMOVE ROAD"

    require './lib/a_star'

    roads = Cell.where('user_id = ? and building_code = ? and idle = true', user.id, BUILDING[:road][:code]).pluck(:x,  :y)
    find = true
    roads_arredores = []
    arredores = arredores(1)
    roads_arredores << arredores[1] if arredores[1].is_road
    roads_arredores << arredores[3] if arredores[3].is_road
    roads_arredores << arredores[5] if arredores[5].is_road
    roads_arredores << arredores[7] if arredores[7].is_road

    #construcoes ao redor

    construcoes_ao_redor = []
    arredores.each do |c|
      if c.user_id == user.id and !c.is_road and c.id != self.id
        construcoes_ao_redor << c
      end
    end

    estradas_encontradas = 0

    construcoes_ao_redor.each do |c|
      c_arredores = c.arredores(1)
      c_arredores.each do |c_a|
        if c_a.is_road and c_a.id != self.id
          estradas_encontradas += 1
          break
        end
      end
    end

    map_creator = []

    logger.info "#{Time.now.to_f} Start path finding to remove road"

    if roads.include? [self.x, self.y]
      roads.delete [self.x, self.y]

      roads_arredores.each_with_index do |r, i|
        map_creator << ""
        (0..256).each do |x|
          (0..256).each do |y|
            if user.castle_x == x and user.castle_y == y
              map_creator[i] << "@"
            elsif r.x == x and r.y == y
              map_creator[i] << "X"
            elsif roads.include? [x, y]
              map_creator[i] << "."
            else
              map_creator[i] << "~"
            end
          end
          map_creator[i] << "\n"
        end

        map = Map.new map_creator[i]

        begin
          map.find_route
        rescue
          find = false
        end
      end
    else
      find = false
    end

    logger.info "#{Time.now.to_f} End path finding to remove road"

    if find and estradas_encontradas == construcoes_ao_redor.size
      true
    else
      false
    end
  end


  def terrain_can_build(terrain, building)
    return true if building[:code] == BUILDING[:castle][:code] and building_level > 0
    terrain[:buildings].each do |b|
      return true if b == building[:code]
    end

    false
  end

  def top_left(cells)
    cells.each do |c|
      return c if c.x == x+1 and c.y == y-1
    end
    Cell.new
  end

  def top_right(cells)
    cells.each do |c|
      return c if c.x == x-1 and c.y == y-1
    end
    Cell.new
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

  def bottom_right(cells)
    cells.each do |c|
      return c if c.x == x+1 and c.y == y+1
    end
    Cell.new
  end

  def bottom_left(cells)
    cells.each do |c|
      return c if c.x == x-1 and c.y == y+1
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

  def have_user_bridge(user_id)
    arredores = arredores(1)

    return true if arredores[1].is_bridge and arredores[1].user_id == user_id
    return true if arredores[3].is_bridge and arredores[3].user_id == user_id
    return true if arredores[5].is_bridge and arredores[5].user_id == user_id
    return true if arredores[7].is_bridge and arredores[7].user_id == user_id

    false
  end

  def can_build_road(user_id)
    arredores = arredores(1)

    return true if arredores[1].is_road and arredores[1].user_id == user_id
    return true if arredores[3].is_road and arredores[3].user_id == user_id
    return true if arredores[5].is_road and arredores[5].user_id == user_id
    return true if arredores[7].is_road and arredores[7].user_id == user_id

    false
  end

  def can_build_wall(user_id)
    arredores = arredores(1)

    (0..8).each do |i|
      if i != 4
        return true if arredores[i].user_id == user_id and !arredores[i].is_wall and is_grass
      end
    end

    false
  end

  def can_to_grass(user_id)
    arredores = arredores(1)

    (0..8).each do |i|
      if i != 4
        return true if arredores[i].user_id == user_id and !arredores[i].is_wall and (is_tree or is_stone or is_gold) and idle
      end
    end

    false
  end

  def have_user_road(user_id)
    arredores = arredores(1)

    (0..8).each do |i|
      if i != 4
        return true if arredores[i].is_road and arredores[i].user_id == user_id
      end
    end

    false
  end

  def sprite_can_build_in_cells(user_id, cells)
    top_cell = top(cells)
    left_cell = left(cells)
    bottom_cell = bottom(cells)
    right_cell = right(cells)

    top_left = top_left(cells)
    top_right = top_right(cells)
    bottom_left = bottom_left(cells)
    bottom_right = bottom_right(cells)

    return true if bottom_left.user_id == user_id and !bottom_left.is_wall
    return true if bottom_right.user_id == user_id and !bottom_right.is_wall
    return true if top_left.user_id == user_id and !top_left.is_wall
    return true if top_right.user_id == user_id and !top_right.is_wall

    return true if top_cell.user_id == user_id and !top_cell.is_wall
    return true if left_cell.user_id == user_id and !left_cell.is_wall
    return true if bottom_cell.user_id == user_id and !bottom_cell.is_wall
    return true if right_cell.user_id == user_id and !right_cell.is_wall

    false
  end

  def have_user_road_in_cells(user_id, cells)
    top_cell = top(cells)
    left_cell = left(cells)
    bottom_cell = bottom(cells)
    right_cell = right(cells)

    top_left = top_left(cells)
    top_right = top_right(cells)
    bottom_left = bottom_left(cells)
    bottom_right = bottom_right(cells)

    return true if bottom_left.user_id == user_id and bottom_left.is_road
    return true if bottom_right.user_id == user_id and bottom_right.is_road
    return true if top_left.user_id == user_id and top_left.is_road
    return true if top_right.user_id == user_id and top_right.is_road

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

    range = 6

    min_x = x-range
    max_x = x+range-1
    min_y = y-range
    max_y = y+range-1

    Cell.where('x > ? and x < ? and y > ? and y < ?', min_x, max_x, min_y, max_y).order('y ASC, x ASC')
  end

  def next_road
    arredores = arredores(1)

    #top left right bottom
    return arredores[1] if arredores[1].is_road and arredores[1].user_id == self.user_id
    return arredores[3] if arredores[3].is_road and arredores[3].user_id == self.user_id
    return arredores[5] if arredores[5].is_road and arredores[5].user_id == self.user_id
    return arredores[7] if arredores[7].is_road and arredores[7].user_id == self.user_id
    #diagonais
    return arredores[0] if arredores[0].is_road and arredores[0].user_id == self.user_id
    return arredores[2] if arredores[2].is_road and arredores[2].user_id == self.user_id
    return arredores[6] if arredores[6].is_road and arredores[6].user_id == self.user_id
    return arredores[8] if arredores[8].is_road and arredores[8].user_id == self.user_id

    arredores_longe = arredores(2)

    arredores_longe.each do |a|
      return a if a.is_road and a.user_id == user_id
    end
    nil
  end

  def move_units_to_next_road
    cell_units.each do |u|
      u.move(next_road)
    end
  end

  def destroy_building
    building = Building.get_building(building_code)
    user_data = UserData.find_by_user_id(user_id)
    terrain = Terrain.get_terrain(terrain_code)

    decrement_house = decrement_score = decrement_storage = 0
    (0..building_level).each do |b|
      decrement_score += building[:levels][b][:score].to_i
      decrement_storage += building[:levels][b][:storage].to_i
      decrement_house += building[:levels][b][:population].to_i
    end

    user_data.storage -= decrement_storage
    user_data.score -= decrement_score
    user_data.max_pop -= decrement_house
    user_data.total_roads -= 1 if is_road
    user_data.save

    user_data.have_blacksmith = false if is_blacksmith
    user_data.have_market = false if is_market

    self.idle = true
    self.cell_units.update_all({cell_id: self.next_road.id})
    self.building_level = 0
    self.building_code = 0
    self.user_id = nil
    self.save
  end

  def road_css_class(cells)
    top_cell = top(cells)
    left_cell = left(cells)
    bottom_cell = bottom(cells)
    right_cell = right(cells)

    name = 'bridge'
    if is_water
      name = 'bridge'
    else
      name = 'road'
    end

    return "sprite-#{name}" if building_level == 0

    return "sprite-#{name}-bt-90"  if right_cell.is_road and !left_cell.is_road and !top_cell.is_road and !bottom_cell.is_road
    return "sprite-#{name}-bt-90"  if !right_cell.is_road and left_cell.is_road and !top_cell.is_road and !bottom_cell.is_road
    return "sprite-#{name}-bt-90"  if right_cell.is_road and left_cell.is_road and !top_cell.is_road and !bottom_cell.is_road

    return "sprite-#{name}-br"     if right_cell.is_road and !left_cell.is_road and !top_cell.is_road and bottom_cell.is_road
    return "sprite-#{name}-br-90"  if !right_cell.is_road and left_cell.is_road and !top_cell.is_road and bottom_cell.is_road
    return "sprite-#{name}-br-180" if !right_cell.is_road and left_cell.is_road and top_cell.is_road and !bottom_cell.is_road
    return "sprite-#{name}-br-270" if right_cell.is_road and !left_cell.is_road and top_cell.is_road and !bottom_cell.is_road

    return "sprite-#{name}-btr"     if right_cell.is_road and !left_cell.is_road and top_cell.is_road and bottom_cell.is_road
    return "sprite-#{name}-btr-90"  if right_cell.is_road and left_cell.is_road and !top_cell.is_road and bottom_cell.is_road
    return "sprite-#{name}-btr-180" if !right_cell.is_road and left_cell.is_road and top_cell.is_road and bottom_cell.is_road
    return "sprite-#{name}-btr-270" if right_cell.is_road and left_cell.is_road and top_cell.is_road and !bottom_cell.is_road

    return "sprite-#{name}-all"    if right_cell.is_road and left_cell.is_road and top_cell.is_road and bottom_cell.is_road

    "sprite-#{name}-bt-180"
  end

  def wall_css_class(cells)
    top_cell = top(cells)
    left_cell = left(cells)
    bottom_cell = bottom(cells)
    right_cell = right(cells)

    return "sprite-wall" if building_level == 0

    return "sprite-wall-bt-90"  if right_cell.is_wall and !left_cell.is_wall and !top_cell.is_wall and !bottom_cell.is_wall
    return "sprite-wall-bt-90"  if !right_cell.is_wall and left_cell.is_wall and !top_cell.is_wall and !bottom_cell.is_wall
    return "sprite-wall-bt-90"  if right_cell.is_wall and left_cell.is_wall and !top_cell.is_wall and !bottom_cell.is_wall

    return "sprite-wall-br"     if right_cell.is_wall and !left_cell.is_wall and !top_cell.is_wall and bottom_cell.is_wall
    return "sprite-wall-br-90"  if !right_cell.is_wall and left_cell.is_wall and !top_cell.is_wall and bottom_cell.is_wall
    return "sprite-wall-br-180" if !right_cell.is_wall and left_cell.is_wall and top_cell.is_wall and !bottom_cell.is_wall
    return "sprite-wall-br-270" if right_cell.is_wall and !left_cell.is_wall and top_cell.is_wall and !bottom_cell.is_wall

    return "sprite-wall-btr"     if right_cell.is_wall and !left_cell.is_wall and top_cell.is_wall and bottom_cell.is_wall
    return "sprite-wall-btr-90"  if right_cell.is_wall and left_cell.is_wall and !top_cell.is_wall and bottom_cell.is_wall
    return "sprite-wall-btr-180" if !right_cell.is_wall and left_cell.is_wall and top_cell.is_wall and bottom_cell.is_wall
    return "sprite-wall-btr-270" if right_cell.is_wall and left_cell.is_wall and top_cell.is_wall and !bottom_cell.is_wall

    return "sprite-wall-all"    if right_cell.is_wall and left_cell.is_wall and top_cell.is_wall and bottom_cell.is_wall

    "sprite-wall-bt-180"
  end

  def self.render_layers(cells, current_user)
    html  = ''
    sprites_layer_1 = ''
    sprites_layer_2 = ''
    sprites_layer_3 = ''

    cells.each do |cell|

      # TERRAINS

      sprites_layer_1 << "<div class='sprite #{cell.terrain_sprite}'></div>"

      # BUILDINGS

      building = Building.get_building(cell.building_code)
      villager_action = ''

      if building != nil
        if cell.user_id == current_user.id
          villager_action = "v-action='#{building[:action]}'" if building[:action]
        end
        if cell.is_road
          sprites_layer_2 << "<div class='sprite #{cell.road_css_class(cells)}-#{cell.building_level}'></div>"
        elsif cell.is_wall
          sprites_layer_2 << "<div class='sprite #{cell.wall_css_class(cells)}-#{cell.building_level}'></div>"
        else
          sprites_layer_2 << "<div class='sprite #{building[:css_class]}-#{cell.building_level}'></div>"
        end
      else
        if cell.sprite_can_build_in_cells(current_user.id, cells)
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
      sprites_layer_3 << "<div class='battle-chronometer chronometer' data_time='#{cell.event_battle.event.wait_time}'></div>" if cell.event_battle

      cell.cell_units.each do |u|
        unity = Unit.get_unit(u.unit)


        sprites_layer_3 << "<div class='sprite-unit #{unity[:css_class]}' obj_id='#{u.id}'>"
        if u.hurt
          sprites_layer_3 << "<div class='sprite-unit-hurt'></div>"
        end
        sprites_layer_3 << "</div>"
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

  def have_unit
    true if CellUnit.where('cell_id = ?', id).first.nil?
  end

  def build(user_data, current_user, building_code)
    building = Building.get_building(building_code.to_i)
    terrain = Terrain.get_terrain(terrain_code)

    return 'Você já tem um mercado' if user_data.have_market and building_code == BUILDING[:market][:code].to_s and building_level == 0
    return 'Você já tem um ferreiro' if user_data.have_blacksmith and building_code == BUILDING[:blacksmith][:code].to_s and building_level == 0

    return 'Ocupado' unless idle?
    return 'Nível máximo atingido' if building[:levels][building_level+1].nil?
    return "Requer castelo nível #{building[:levels][building_level+1][:castle_level].to_i}" unless current_user.castle.building_level >= building[:levels][building_level+1][:castle_level].to_i
    return 'Você não pode construir neste terreno' unless terrain_can_build(terrain, building)
    return 'Voce não pode evoluir um edificio com pessoas dentro' unless have_unit


    if building_code == BUILDING[:wall][:code].to_s
      return 'Vocês não pode construir muralha aqui' if !can_build_wall(current_user.id)
    else
      unless have_user_road current_user.id
        if have_user_bridge(current_user.id) and building_code == BUILDING[:road][:code].to_s and is_grass

        else
          return 'Suas estradas não chegam até aqui'
        end
      end
    end

    if building_code == BUILDING[:road][:code].to_s
      return 'Você não pode fazer estrada na diagonal' unless can_build_road(current_user.id)
    end

    if is_water and building_code == BUILDING[:road][:code].to_s
      return 'Você não possui recursos' unless user_data.have_recourses building[:bridge_levels][building_level+1]
    else
      return 'Você não possui recursos' unless user_data.have_recourses building[:levels][building_level+1]
    end


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
    if is_water and building_code == BUILDING[:road][:code].to_s
      user_data.use_recourses building[:bridge_levels][building_level+1]
    else
      user_data.use_recourses building[:levels][building_level+1]
    end

    event = Event.new
    event.start_time = Time.now.to_i
    event.end_time = Time.now.to_i + building[:levels][building_level+1][:time]
    event.event_type = :building_up

    self.building_code = building_code
    self.user_id = current_user.id
    self.idle = false

    idle_villager.cell_id = self.id

    require 'rmagick'
    img = Magick::Image.read('public/world.bmp')[0]
    img.pixel_color(x, y, current_user.color)
    img.write('public/world.bmp')
    
    user_data.save
    event.save
    EventBuildingUp.create({cell_id: id, event_id: event.id})
    self.save
    idle_villager.save
    
    true
  end

end
