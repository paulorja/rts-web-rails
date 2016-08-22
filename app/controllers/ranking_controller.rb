class RankingController < ApplicationController

  def general
    @users = User.includes(:user_data).joins(:user_data).where('user_type = 0').order('user_data.score DESC')
  end

  def territories
    @users = User.includes(:user_data).joins(:user_data).where('user_type = 0').order('user_data.total_territories DESC')
  end

end
