class ReportController < ApplicationController
  def home
    @reports = Report.includes(:user, :user_2).where('user_id = ?', @current_user.id).order('created_at DESC')
  end

  def market
    @reports = ReportMarketOffer.joins(:report).where('reports.user_id = ?', @current_user.id).order('reports.created_at DESC')
  end
end
