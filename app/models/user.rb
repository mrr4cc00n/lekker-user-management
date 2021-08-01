class User < ApplicationRecord
  has_secure_password

  enum status: [:unarchived, :archived ]

  validates :email,
    presence: true,
    uniqueness: true
end
