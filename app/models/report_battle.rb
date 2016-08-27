class ReportBattle < ActiveRecord::Base
  belongs_to :report
  belongs_to :battle
end
