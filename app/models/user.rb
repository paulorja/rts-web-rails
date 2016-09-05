class User < ActiveRecord::Base

  validates :login, presence: true, length: {maximum: 12, minimum: 4}, uniqueness: true
  validates :password, presence: true, length: {maximum: 16, minimum: 4}
  validates :password, confirmation: true


  enum user_type: [:player, :admin]

  has_one :user_data, dependent: :destroy

  def create_user_data start_position
    UserData.start_user_data(self.id)

    update_attributes({
        castle_x: start_position[:castle].x,
        castle_y: start_position[:castle].y
    })

    require 'rmagick'
    img = Magick::Image.read('public/world.bmp')[0]

    start_position[:castle].building_code = BUILDING[:castle][:code]
    start_position[:castle].building_level = 1
    start_position[:castle].user_id = id
    start_position[:castle].save
    img.pixel_color(start_position[:castle].x, start_position[:castle].y, color)

    start_position[:roads].each_with_index do |road, index|
      if index == 1
        road.cell_units.create({unit: 1, user_id: id, name: CellUnit.random_name, attack: UNIT[:villager][:attack]})
        road.cell_units.create({unit: 1, user_id: id, name: CellUnit.random_name, attack: UNIT[:villager][:attack]})
      end

      road.building_code = BUILDING[:road][:code]
      road.building_level = 1
      road.user_id = id
      road.save
      img.pixel_color(road.x, road.y, color)
    end

    img.write('public/world.bmp')
  end

  def idle_villager
    CellUnit.joins(:cell).where('cells.idle = true and cells.building_code = ? and cell_units.user_id = ? and cell_units.unit = 1 and cell_units.hurt = false', BUILDING[:road][:code], id).first
  end


  def castle
    Cell.where('x = ? and y = ?', castle_x, castle_y).first
  end

  def castle_path
    "/world_zoom/#{castle_x}/#{castle_y}"
  end

  def have_building(code)
    true unless Cell.where('building_code = ? and user_id = ?', code, self.id).first.nil?
  end

  def self.user_distance(u1, u2)
    Cell.point_distance(u1.castle_x, u1.castle_y, u2.castle_x, u2.castle_y)
  end

  def all_armies
    CellUnit.where('unit != ? and user_id = ? and idle = true', UNIT[:villager][:code], id)
  end

end
