class RankingController < ApplicationController

  def general
    @users = User.includes(:user_data).joins(:user_data).where('user_type = 0').order('user_data.score DESC')
  end

  def territories
    @users = User.includes(:user_data).joins(:user_data).where('user_type = 0').order('user_data.total_territories DESC')
  end

  def population
    @users = User.includes(:user_data).joins(:user_data).where('user_type = 0').order('user_data.total_pop DESC')
  end

  def atk
    @users = User.includes(:user_data).joins(:user_data).where('user_type = 0').order('user_data.total_atk DESC')
  end

  def def
    @users = User.includes(:user_data).joins(:user_data).where('user_type = 0').order('user_data.total_def DESC')
  end

  def best_soldier
    @soldiers = CellUnit.includes(:user).joins(:user).order('cell_units.attack DESC').limit(100)
  end

end
