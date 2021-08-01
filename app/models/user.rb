class User < ApplicationRecord
  has_secure_password

  before_destroy :notify_user_deletion

  has_many  :user_operations

  enum status: [:unarchived, :archived ]

  validates :email,
    presence: true,
    uniqueness: true

  private
  # Triggered before a user is destroyed, sends a notification via email to the user
  def notify_user_deletion
    UserMailer.operation_performed(user_email: self.email, action: 'deleted').deliver_now
  end
end
