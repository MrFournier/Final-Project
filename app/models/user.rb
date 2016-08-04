class User < ApplicationRecord
  has_one :pet

  has_secure_password

  validates :username, presence: true

  validates :email, presence: true
end
