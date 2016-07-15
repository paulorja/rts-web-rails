module WorldHelper
  require 'rmagick'

  def update_world_pixel(x, y, color)

    img = Magick::Image.read('app/assets/images/world.bmp')[0]

    img.pixel_color(x.to_i, y.to_i, color)

    img.write('app/assets/images/world.bmp')
  end

  def get_user_start_position
    roads = nil
    castle = nil

    while roads.nil? or castle.nil?
      roads = nil

      ActiveRecord::Base.connection.clear_query_cache
      castle = Cell.where('terrain_code = ?', 2).order('RAND()').first

      if castle.x > 0 and castle.x < 255 and castle.y > 0 and castle.x < 255
        arredores = castle.arredores(1)

        arredores.each do |cell|
          if cell.have_building or cell.is_gold
            castle = nil
            break
          end
        end

        if arredores[0].is_grass and arredores[1].is_grass and arredores[2].is_grass
          roads = [arredores[0], arredores[1], arredores[2]]
        elsif arredores[6].is_grass and arredores[7].is_grass and arredores[8].is_grass
          roads = [arredores[6], arredores[7], arredores[8]]
        elsif arredores[0].is_grass and arredores[3].is_grass and arredores[6].is_grass
          roads = [arredores[0], arredores[3], arredores[6]]
        elsif arredores[2].is_grass and arredores[5].is_grass and arredores[8].is_grass
          roads = [arredores[2], arredores[5], arredores[8]]
        end
      else
        castle = nil
      end
    end

    {
        castle: castle,
        roads: roads
    }
  end

end
