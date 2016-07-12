
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
    castle: building_config('castle')
}