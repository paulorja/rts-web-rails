class Map < ActiveRecord::Base

  def self.user_run
    img = Magick::Image.read('public/world.bmp')[0]
    map = img.get_pixels(0, 0, 256, 256)
    string_map = ""
    roads = Cell.where('user_id = ? and building_code = ? and idle = true', 2, BUILDING[:road][:code]).pluck(:x,  :y)


    map.each_with_index do |p, i|
      y = i / 256
      x = i % 256

      string_map << "\n" if i > 1 and x == 0

      grass = TERRAIN[:grass][:color]
      gold = TERRAIN[:gold][:color]
      tree = TERRAIN[:tree][:color]
      stone = TERRAIN[:stone][:color]

      if Map.color_eql(p, grass) or Map.color_eql(p, gold) or Map.color_eql(p, tree) or Map.color_eql(p, stone)
        string_map << "~"
      elsif roads.include? [x, y]
        string_map << "~"
      else
        string_map << "."
      end
    end

    puts string_map

    return string_map
  end

  def self.color_eql(map_pixel, terrain)
    true if map_pixel.red/257 == terrain[0] and map_pixel.blue/257 == terrain[2] and map_pixel.green/257 == terrain[1]
  end

end
