
class Unit
  def self.get_unit(code)
    UNIT.each do |u|
      if u[1][:code] == code
        return u[1]
      end
    end
    nil
  end
end

def unit_config name
  load("config/units/#{name}.rb")

  @unit_data
end

UNIT = {
    villager: unit_config('villager'),
    lancer: unit_config('lancer'),
    swordsman: unit_config('swordsman'),
    archer: unit_config('archer'),
}