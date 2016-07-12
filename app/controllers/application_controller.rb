class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_current_user
  before_action :resolve_events

  def set_current_user
    if session['current_user_id']
      user = User.includes(:user_data).where('id = ?', session['current_user_id']).first
      @current_user = user
      @user_data = user.user_data
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

  include WorldHelper

  def resolve_events
    Event.resolve_events
  end

end
