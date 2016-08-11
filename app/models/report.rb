class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_2, class_name: 'User', foreign_key: :user_2_id

  enum report_type: [
      :user_accept_offer,
      :user_recourses_arrived
  ]

  def self.report_detail(report_id, user_data)
    report = Report.find(report_id.to_i)

    unless report.read.trust
      report.update_attribute(:read, true)
      user_data.update_attribute(:new_reports, user_data.new_reports-1)
    end
  end

end
