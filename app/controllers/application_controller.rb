class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_current_user, :update_recourses, :resolve_events, :set_last_xy
  include WorldHelper

  def set_current_user
    if session['current_user_id']
      user = User.includes(:user_data).where('id = ?', session['current_user_id']).first
      @current_user = user
      @user_data = user.user_data if @current_user
    end
  end

  def require_user
    if current_user.nil?
      redirect_to root_path
    end
  end

  def require_admin
    if @current_user.nil? or @current_user.admin? == false
      redirect_to root_path
    end
  end


  def resolve_events
    Event.resolve_events
  end

  def update_recourses
    unless @current_user.nil?
      @current_user.user_data.update_recourses
    end
  end

  def set_x_y
    if params[:x]
      @x = params[:x]
    else
      @x = 0
    end

    if params[:x]
      @y = params[:y]
    else
      @y = 0
    end
  end

  def set_last_xy
    if params[:x] and params[:y]
      session['last_x'] = params[:x]
      session['last_y']  = params[:y]
    end
  end

end
