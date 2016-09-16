class WorldMap < ActiveRecord::Base

  def self.attack_route(user, cell)
    require './lib/pathfinding_map'
    require 'set'

    img = Magick::Image.read('public/world.bmp')[0]
    map_pxl = img.get_pixels(0, 0, 256, 256)
    string_map = ""
    roads = Cell.where('user_id = ? and building_code = ? and idle = true', user.id, BUILDING[:road][:code]).pluck(:x,  :y)

    blocked_cells = Set.new 
    map_pxl.each_with_index do |p, i|
      y = i / 256
      x = i % 256

      string_map << "\n" if i > 1 and x == 0

      grass = TERRAIN[:grass][:color]
      gold = TERRAIN[:gold][:color]
      tree = TERRAIN[:tree][:color]
      stone = TERRAIN[:stone][:color]

      if cell.x == x and cell.y == y
        end_p = {x: x, y: y}
      elsif user.castle_x == x and user.castle_y == y
        start_p = {x: x, y: y}
      elsif WorldMap.color_eql(p, grass) or WorldMap.color_eql(p, gold) or WorldMap.color_eql(p, tree) or WorldMap.color_eql(p, stone)
      
      elsif roads.include? [x, y]
      
      else
        blocked_cells.add([x, y])
      end
    end

    map = PathfindingMap.new(blocked_cells)

    logger.info "#{Time.now.to_f} Start find route"
    route = map.find_path(start_p[:x], start_p[:y], end_p[:x], end_p[:y])
    logger.info "#{Time.now.to_f} End find route"
    
    return route
  end

  def self.route_to_img(route)
    require './lib/WorldCreation'

    img = Magick::Image.read('public/world.bmp')[0]

    route.each do |r|
      img.pixel_color(r[0], r[1], 'red')
    end

    img.write('public/worldtest.bmp')

    return img
  end

  def self.color_eql(map_pixel, terrain)
    true if map_pixel.red/257 == terrain[0] and map_pixel.blue/257 == terrain[2] and map_pixel.green/257 == terrain[1]
  end



end
