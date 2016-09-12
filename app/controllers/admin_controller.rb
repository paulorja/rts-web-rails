class AdminController < ApplicationController

  before_action :require_admin, except: [:resolve_all_events, :more_recourses]

  def home

  end

  def reset_world
    require './lib/WorldCreation'
    conn = ActiveRecord::Base.connection
    WorldCreation.new(conn)
    redirect_to '/admin'
  end

  def resolve_all_events
    Event.all.update_all(end_time: 0) if Rails.env.development?
    redirect_to :back
  end

  def more_recourses
    @current_user.user_data.update_attributes({wood: 999999, gold: 999999, food: 999999, stone: 999999}) if Rails.env.development?
    redirect_to :back
  end

end
