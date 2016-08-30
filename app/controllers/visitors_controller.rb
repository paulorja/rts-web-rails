class VisitorsController < ApplicationController

  def home
    @random_color = '#' + ("%06x" % (rand * 0xffffff)).to_s

    render file: 'visitors/home', layout: false
  end

end
