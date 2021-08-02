class UserMailer < ApplicationMailer
  def operation_performed(user_email:, action:)
    @user = user_email
    @action_performed = action
    mail to: user_email,
         from: '<info@test.com>',
         subject: "Your user was #{action}"
  end
end