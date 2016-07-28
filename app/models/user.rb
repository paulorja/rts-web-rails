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
      road.villagers = '1;2' if index == 1

      road.building_code = BUILDING[:road][:code]
      road.building_level = 1
      road.user_id = id
      road.save
      img.pixel_color(road.x, road.y, color)
    end

    img.write('public/world.bmp')
  end

  def castle
    Cell.where('x = ? and y = ?', castle_x, castle_y).first
  end

  def castle_path
    "/world_zoom/#{castle_x}/#{castle_y}"
  end
end
