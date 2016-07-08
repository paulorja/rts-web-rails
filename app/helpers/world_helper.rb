module WorldHelper
  require 'rmagick'

  def update_world_pixel(x, y, color)

    img = Magick::Image.read('app/assets/images/world.bmp')[0]

    img.pixel_color(x.to_i, y.to_i, color)

    img.write('app/assets/images/world.bmp')
  end

  def get_user_start_position




  end

end
