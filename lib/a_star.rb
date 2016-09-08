class TileType
   attr_reader :cost
   attr_reader :sym
   def initialize(sym, cost)
       @cost = cost
       @sym = sym
   end
     def passable?
       cost > 0
   end
     def newTile(x, y)
       Tile.new(x, y, self)
   end
end

class StartTileType < TileType
   def newTile(x, y)
       $start = Tile.new(x, y, self)
   end
end

class GoalTileType < TileType
   def newTile(x, y)
       $goal = Tile.new(x, y, self)
   end
end

TYPES = {
   '@' => StartTileType.new('@', 1),
   '.' => TileType.new('.', 1),
   'X' => GoalTileType.new('X', 1),
   '~' => TileType.new('~', 0),
   '*' => TileType.new('*', 2),
   '^' => TileType.new('^', 3)
}

POINTS = [
   [-1, 0],
   [0, -1], [0, 1],
   [1, 0]
]

class Tile
   attr_reader :x, :y
   def initialize(x, y, type)
       @x = x
       @y = y
       @type = type
   end
     def distance(goal)
       (@x - goal.x).abs + (@y - goal.y).abs
   end
     def cost(goal)
       distance(goal) + @type.cost
   end
     def passable?
       @type.passable?
   end
     def sym
       @type.sym
   end
end

class Map
   def initialize(mapstring)
       @map = []
       @height = 0
       mapstring.split.each_with_index do |line, y|
           @width = line.size
           @height += 1
           line.split("").each_with_index do |c, x|
               @map << TYPES[c].newTile(x, y)
           end
       end
   end
     def get(x, y)
       if(x >= 0 && x < @width && y >= 0 && y < @height)
           @map[x + @width * y]
       end
   end
     def adjacent(t)
       result = []
       POINTS.each do |dx, dy|
           test = get(t.x + dx, t.y + dy)
           result << test if test
       end
       result
   end
     def find_route
       @route = [$start]
       @current = $start
       checked = []
       bad = []
       while(@current != $goal)
           #find adjacent tiles
           choices = adjacent(@current).select{|t| t.passable? && !(checked.flatten + bad + @route).include?(t)}
           if(choices.size == 0)
               ##need to backtrack
               bad.push @current
               @current = @route.pop
               checked.pop
           else
               #sort by cost
               choices = choices.sort_by{|t| t.cost($goal)}
               checked.push choices
               #take lowest
               @current = choices.shift
               @route.push @current
           end
       end
       @route
   end
     def tile_to_s(t)
       if(@route && @route.include?(t))
           '#'
       else
           t.sym
       end
   end
     def print
       line = ""
       @map.each_with_index do |t, i|
           if(i > 0 && (i % @width ==0))
               puts line
               line = ""
           end
           line << tile_to_s(t)
       end
       puts line
   end
end

TESTMAP = <<-ENDTEST
~......~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~.~~~~.............................................................................~~~~~~~~~~~~~~~~~~~~~~~.~~~~~~~~
~..@...~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.~~~~~~~~~~~~~~~~~~~~~~~.~~~~~~~~
~.~~~......................................................................................................~~~~~~~~
~.~~~..~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~.~~~.............................................................~~~~~~~~~~~~~~~~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~.~~~..~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~.~~~..~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~....................................................................~~~
~.~~~..~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.~~~~~~~~~~.~~~~~~~~~~~~~~~~~~~~~
~.~~~..~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.~~~~~~...............~~~~~~~~~~~
~.~~~..............................................................................~~~~~~.~~~~~~~~~~~~~.~~~~~~~~~~~
~.~~~..~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.~~~~.............~~~~~~~~
~.~~~..~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~........~~~~.~~~~~~~~~~~.~~~~~~~~
~.~~~..~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.~~~~~~~~~~~.........X~~.~~~~~~~~
~.~~~..~~~~~~~~~~..............................................................~~~.~~~~~~~~~~~~~~~~~~~~~~~.~~~~~~~~
~.~~~..~~~~~~~~~~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.....~~~~~~~~~~~~~~~~~~~~~~~.~~~~~~~~
~.~~~..~~~~~~~~~~.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.~~~~~~~~
~.~...........................................~..............................................................~~~~~~
~....~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ENDTEST

map = Map.new TESTMAP
map.print
puts ""
begin
  map.find_route
  map.print
rescue
  puts "Rota impossivel"
end
