class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_2, class_name: 'User', foreign_key: :user_2_id

  enum report_type: [
      :user_accept_offer,
      :user_recourses_arrived,
      :battle
  ]

  def self.report_detail(report_id, user_data)
    report = Report.find(report_id.to_i)

    if report.user_id == user_data.user.id
      unless report.read.trust
        report.update_attribute(:read, true)
        user_data.update_attribute(:new_reports, user_data.new_reports-1)
      end

      report
    end
  end

  def title
    case report_type
      when 'user_recourses_arrived'
        return "Chegaram recursos de #{user_2.login}"
      when 'user_accept_offer'
        return "#{user_2.login} aceitou sua oferta"
      when 'battle'
        return ''
      else
        return 'OPS'
    end
  end

end
