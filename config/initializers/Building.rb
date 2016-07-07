BUILDING = {
    house: {
        name: 'Casa',
        code: 1,
        css_class: 'sprite-house'
    },
    road: {
        name: 'Estrada',
        code: 2,
        css_class: 'sprite-road'
    },
    town_center: {
        name: 'Centro de Cidade',
        code: 3,
        css_class: 'sprite-town-center'
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

