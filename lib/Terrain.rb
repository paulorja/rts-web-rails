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
    terrain[:iron]    = Terrain.new('Iron',    [170, 170, 170], '/terrain/iron')
    terrain[:gold]    = Terrain.new('Gold',    [255, 255, 0], '/terrain/gold')
    terrain[:diamond] = Terrain.new('Diamond', [0, 255, 255], '/terrain/diamond')

    terrain
  end

  def self.color_to_code(color)
    case color
    when [91, 104, 200]
      return 4
    when [119, 232, 104]
      return 2
    else
      return 3
    end
  end

end