class VisitorsController < ApplicationController

  def home
    render file: 'visitors/home', layout: false
  end

end
