class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_2, class_name: 'User', foreign_key: :user_2_id

  enum report_type: [
      :user_accept_offer,
      :user_recourses_arrived
  ]

end
