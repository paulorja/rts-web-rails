module WorldHelper
  require 'rmagick'

  def update_world_pixel(x, y, color)

    img = Magick::Image.read('public/world.bmp')[0]

    img.pixel_color(x.to_i, y.to_i, color)

    img.write('public/world.bmp')
  end

  def get_user_start_position
    roads = castle = recourses = nil

    while roads.nil? or castle.nil? or recourses.nil?
      roads = nil
      recourses = nil

      ActiveRecord::Base.connection.clear_query_cache
      castle = Cell.where('terrain_code = ?', 2).order('RAND()').first

      if castle.x > 5 and castle.x < 250 and castle.y > 5 and castle.x < 250

        arredores3 = castle.arredores(3)
        wood = gold = stone = nil
        arredores3.each do |cell|
          wood = true if cell.is_tree
          stone = true if cell.is_stone
          gold = true if cell.is_gold

          recourses = true if wood and gold and stone
          break if recourses
        end


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
