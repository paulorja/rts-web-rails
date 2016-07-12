TERRAIN = {
    grass: {
        name: 'Grama',
        code: 2,
        color: [119, 232, 104],
        css_class: 'sprite-grass',
        buildings: [:house, :road, :storage]
    },
    tree: {
        name: 'Floresta',
        code: 3,
        color: [62, 143, 51],
        css_class: 'sprite-tree',
        buildings: []
    },
    water: {
        name: 'Água',
        code: 4,
        color: [91, 104, 200],
        css_class: 'sprite-water',
        buildings: []
    },
    stone: {
        name: 'Mina de Pedra',
        code: 5,
        color: [170, 170, 170],
        css_class: 'sprite-stone',
        buildings: []
    },
    gold: {
        name: 'Mina de Ouro',
        code: 6,
        color: [255, 255, 0],
        css_class: 'sprite-gold',
        buildings: []
    },
    diamond: {
        name: 'Mina de Diamante',
        code: 7,
        color: [0, 255, 255],
        css_class: 'sprite-diamond',
        buildings: []
    }
}


class Terrain
  attr_reader :name, :color, :sprite

  def initialize(name, color, sprite)
    @name = name
    @color = color
    @sprite = sprite
  end

  def self.get_terrains
    terrain = Hash.new()
    terrain[:water]   = Terrain.new('Water',   [91, 104, 200], '/terrain/water')
    terrain[:grass]   = Terrain.new('Grass',   [119, 232, 104], '/terrain/grass')
    terrain[:forest]  = Terrain.new('Forest',  [62, 143, 51], '/terrain/forest')
    terrain[:stone]    = Terrain.new('Stone',    [170, 170, 170], '/terrain/stone')
    terrain[:gold]    = Terrain.new('Gold',    [255, 255, 0], '/terrain/gold')
    terrain[:diamond] = Terrain.new('Diamond', [0, 255, 255], '/terrain/diamond')
    terrain
  end

  def self.color_to_code(color)
    TERRAIN.each do |t|
      if t[1][:color] == color
        return t[1][:code]
      end
    end
    raise 'COLOR NOT FIND'
  end

  def self.get_terrain(code)
    TERRAIN.each do |t|
      if t[1][:code] == code
        return t[1]
      end
    end
    raise 'TERRAIN NOT FIND'
  end
end

