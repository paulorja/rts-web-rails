class ReportBattle < ActiveRecord::Base
  belongs_to :report
  belongs_to :battle


  def save
    super

    Report.create({
        type: ''
    })
  end
end
