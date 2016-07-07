BUILDING = {
    house: {
        name: 'Casa',
        code: 1,
        css_class: 'sprite-house',
        levels: [
            {
                wood: 50,
                gold: 10
            },
            {
                wood: 150,
                gold: 50
            },
            {
                wood: 320,
                gold: 90
            }
        ]
    },
    road: {
        name: 'Estrada',
        code: 2,
        css_class: 'sprite-road',
        terrain: :grass
    },
    town_center: {
        name: 'Centro de Cidade',
        code: 3,
        css_class: 'sprite-town-center',
        terrain: :grass
    }
}


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

