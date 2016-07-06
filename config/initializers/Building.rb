BUILDING = {
    house: {
        name: 'Casa',
        code: 1,
        css_class: 'sprite-house'
    }
}


class Building
  def self.get_building(code)
    BUILDING.each do |b|
      if b[1][:code] == code
        return b[1]
      end
    end
    raise 'BUILDING NOT FOUND'
  end
end

