class WorldCreation
  SIZE = 256
  SQUARES = 512
  SQUARES_MAX_SIZE = 15
  SQUARES_MIN_SIZE = 5

  def initialize(conn)
    require 'rmagick'
    t = Terrain::get_terrains

    map = Array.new(WorldCreation::SIZE) do
      Array.new(WorldCreation::SIZE) do
        t[:water].color
      end
    end

    (0..WorldCreation::SQUARES).each do
      square_size = WorldCreation.get_rand_square_size

      rx = rand(WorldCreation::SIZE)
      ry = rand(WorldCreation::SIZE)


      (0..square_size).each do |y|

        # ELEMENTS
        (0..square_size).each do |x|
          chance = rand(100)

          if chance < 25
            # FOREST
            map[rx+x][ry+y] = TERRAIN[:tree][:color]

            map[rx+x-1][ry+y] = TERRAIN[:tree][:color]
            map[rx+x+1][ry+y] = TERRAIN[:tree][:color]
            map[rx+x][ry+y+1] = TERRAIN[:tree][:color]
            map[rx+x][ry+y-1] = TERRAIN[:tree][:color]

            map[rx+x-1][ry+y+1] = TERRAIN[:tree][:color]
            map[rx+x+1][ry+y-1] = TERRAIN[:tree][:color]
          elsif chance < 40
            # STONE
            map[rx+x][ry+y] = TERR
            AIN[:stone][:color]
            map[rx+x][ry+y+1] = TERRAIN[:stone][:color]
            map[rx+x-1][ry+y] = TERRAIN[:stone][:color]

          elsif chance < 45
            # GOLD
            map[rx+x][ry+y] = TERRAIN[:gold][:color]
          else
            map[rx+x][ry+y] = TERRAIN[:grass][:color]
          end

          map = WorldCreation.serrilhar(map, x, y, rx, ry, square_size)

        end

        #serrilhar leste
        if rand(10) != 1
          map[rx+square_size+1][ry+y] = TERRAIN[:grass][:color]
          if rand(7) != 1
            map[rx+square_size+2][ry+y] = TERRAIN[:grass][:color]
            if rand(2) != 1
              map[rx+square_size+3][ry+y] = TERRAIN[:grass][:color]
            end
          end
        end

        #serrilhar oeste
        if rand(10) != 1
          map[rx-1][ry+y] = TERRAIN[:grass][:color]
          if rand(7) != 1 and rx-2 > 0
            map[rx-2][ry+y] = TERRAIN[:grass][:color]
            if rand(2) != 1 and rx-3 > 0
              map[rx-3][ry+y] = TERRAIN[:grass][:color]
            end
          end
        end
      end
    end


    img = Magick::Image.new(WorldCreation::SIZE, WorldCreation::SIZE)

    query_terrains = 'INSERT INTO cells (x, y, terrain_code) VALUES'
    terrain_values = Array.new

    map.each_with_index do |row, row_index|
      row.each_with_index do |color, column_index|
        if row_index>=0 and row_index<WorldCreation::SIZE and column_index>=0 and column_index<WorldCreation::SIZE
          img.pixel_color(row_index, column_index, "rgb(#{color.join(', ')})")

          terrain_values.push "(#{row_index}, #{column_index}, #{Terrain.color_to_code(color)})"
        end
      end
    end
    img.write('app/assets/images/world.bmp')

    query_terrains << terrain_values.join(', ')+';'

    conn.execute(query_terrains)
  end

  def self.get_rand_square_size
    square_size = rand(self::SQUARES_MAX_SIZE)
    if square_size < self::SQUARES_MIN_SIZE
      square_size= self::SQUARES_MIN_SIZE
    end
    square_size
  end

  def self.serrilhar(map, x, y, rx, ry, square_size)
    # norte
    if rand(10) != 1 and y == 0
      map[rx+x][ry+y-1] = TERRAIN[:grass][:color]
      if rand(9) != 1
        map[rx+x][ry+y-2] = TERRAIN[:grass][:color]
        if rand(2) != 1
          map[rx+x][ry+y-3] = TERRAIN[:grass][:color]
        end
      end
    end

    # sul
    if rand(10) != 1 and y == 0
      map[rx+x][ry+square_size+1] = TERRAIN[:grass][:color]
      if rand(7) != 1
        map[rx+x][ry+square_size+2] = TERRAIN[:grass][:color]
        if rand(2) != 1
          map[rx+x][ry+square_size+3] = TERRAIN[:grass][:color]
        end
      end
    end

    map
  end

end