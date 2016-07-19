class UserController < ApplicationController
  helper WorldHelper

  def post_login
    @user = User.find_by_login(user_params[:login])

    if @user and @user.password == user_params[:password]
      session['current_user_id'] = @user.id
      redirect_to world_path
    else
      redirect_to root_path
    end

  end

  def post_register
    @user = User.new(user_params)
    @user.user_type = User.user_types[:player]

    if @user.save
      @user.create_user_data get_user_start_position

      session['current_user_id'] = @user.id
      redirect_to world_zoom_c_path(@user.castle_x, @user.castle_y)
    else
      redirect_to root_path
    end

  end

  def logout
    reset_session

    redirect_to root_path
  end

  def profile
    @user = User.joins(:user_data).where('login = ?', params[:user_login]).first

    if @user.nil?
      redirect_to root_path
    end
  end


  private
    def user_params
      params.require(:user).permit(:login, :password, :password_confirmation, :color)
    end
end
