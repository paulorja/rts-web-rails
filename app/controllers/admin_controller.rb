class AdminController < ApplicationController

  before_action :require_admin, except: [:resolve_events, :recourses]

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

  def recourses
    if Rails.env.development?
      @current_user.user_data.update_attributes({
                                                    wood: 999999,
                                                    gold: 999999,
                                                    food: 999999,
                                                    stone: 999999
                                                })
    end
    redirect_to :back
  end

  def resolve_events
    if Rails.env.development?
      Event.all.update_all(end_time: 0)
    end
    redirect_to :back
  end

end
