TERRAIN = {}

TERRAIN = {
    grass: {
        code: 2,
        css_class: 'sprite-grass'
    },
    tree: {
        code: 3,
        css_class: 'sprite-tree'
    },
    water: {
        code: 4,
        css_class: 'sprite-water'
    }
}

def get_terrain(code)
  TERRAIN.each do |t|
    if t[1][:code] == code
      return t[1]
    end
  end
end