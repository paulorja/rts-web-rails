class WorldMap < ActiveRecord::Base

  def self.attack_route(user, cell)
    require './lib/a_star'

    img = Magick::Image.read('public/world.bmp')[0]
    map_pxl = img.get_pixels(0, 0, 256, 256)
    string_map = ""
    roads = Cell.where('user_id = ? and building_code = ? and idle = true', user.id, BUILDING[:road][:code]).pluck(:x,  :y)


    map_pxl.each_with_index do |p, i|
      y = i / 256
      x = i % 256

      string_map << "\n" if i > 1 and x == 0

      grass = TERRAIN[:grass][:color]
      gold = TERRAIN[:gold][:color]
      tree = TERRAIN[:tree][:color]
      stone = TERRAIN[:stone][:color]

      if cell.x == x and cell.y == y
        string_map << "X"
      elsif user.castle_x == x and user.castle_y == y
        string_map << "@"
      elsif WorldMap.color_eql(p, grass) or WorldMap.color_eql(p, gold) or WorldMap.color_eql(p, tree) or WorldMap.color_eql(p, stone)
        string_map << "."
      elsif roads.include? [x, y]
        string_map << "."
      else
        string_map << "~"
      end
    end

    map = Map.new string_map

    begin
      return map.find_route
    rescue
      return nil
    end
  end

  def self.route_to_img(route)
    require './lib/WorldCreation'

    img = Magick::Image.read('public/world.bmp')[0]

    route.each_with_index do |r, i|
      img.pixel_color(r.x, r.y, 'red')
    end

    img.write('public/worldtest.bmp')

    return img
  end

  def self.color_eql(map_pixel, terrain)
    true if map_pixel.red/257 == terrain[0] and map_pixel.blue/257 == terrain[2] and map_pixel.green/257 == terrain[1]
  end



end
