
class Building
  def self.get_building(code)
    BUILDING.each do |b|
      if b[1][:code] == code
        return b[1]
      end
    end
    nil
  end
end

def building_config name
  load("config/buildings/#{name}.rb")

  @building_data
end

BUILDING = {
    house: building_config('house'),
    road: building_config('road'),
    storage: building_config('storage'),
    castle: building_config('castle'),
    port: building_config('port'),
    gold_mine: building_config('gold_mine'),
    lumberjack: building_config('lumberjack'),
    stone_mine: building_config('stone_mine'),
    farm: building_config('farm'),
    market: building_config('market'),
    blacksmith: building_config('blacksmith'),
    barrack: building_config('barrack'),
    hospital: building_config('hospital'),
    tower: building_config('tower'),
    bridge: building_config('bridge')
}