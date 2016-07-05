class User < ActiveRecord::Base

  validates :login, presence: true, length: {maximum: 12, minimum: 4}, uniqueness: true
  validates :password, presence: true, length: {maximum: 16, minimum: 4}
  validates :password, confirmation: true

  enum user_type: [:player, :admin]
end
