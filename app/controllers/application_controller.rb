class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    User.where('id = ?', session['current_user_id']).first
  end

  def require_user
    if current_user.nil?
      redirect_to root_path
    end
  end

  def require_admin
    if current_user.nil? or current_user.admin? == false
      redirect_to root_path
    end
  end

end
