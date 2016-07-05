class UserController < ApplicationController
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
      session['current_user_id'] = @user.id
      redirect_to world_path
    else
      redirect_to root_path
    end

  end

  def logout
    reset_session

    redirect_to root_path
  end


  private
    def user_params
      params.require(:user).permit(:login, :password, :password_confirmation)
    end
end
