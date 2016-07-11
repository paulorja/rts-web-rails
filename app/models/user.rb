class User < ActiveRecord::Base

  validates :login, presence: true, length: {maximum: 12, minimum: 4}, uniqueness: true
  validates :password, presence: true, length: {maximum: 16, minimum: 4}
  validates :password, confirmation: true


  enum user_type: [:player, :admin]

  has_one :user_data, dependent: :destroy

  def create_user_data
    UserData.create({user_id: self.id, wood: 50000, gold: 4500})

    require 'rmagick'

    

    img = Magick::Image.read('app/assets/images/world.bmp')[0]
    img.pixel_color(1, 1, 'rgb(254, 254, 254)')

    img.write('app/assets/images/world.bmp')

  end
end
