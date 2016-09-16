class PathfindingMap < Pathfinding

  def initialize(blocked_cells)
    @blocked_cells = blocked_cells
    super(256, 256, 1)
  end

  def blocked?(x,y)
    true if @blocked_cells.include? [x, y]
  end
  
end