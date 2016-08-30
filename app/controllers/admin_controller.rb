class AdminController < ApplicationController

  before_action :require_admin

  def home


  end

  def reset_world
    require './lib/WorldCreation'

    conn = ActiveRecord::Base.connection

    #conn.execute 'TRUNCATE TABLE cells'

    #User.where('user_type = ?', 0).destroy_all

    WorldCreation.new(conn)

    redirect_to '/admin'
  end
end
