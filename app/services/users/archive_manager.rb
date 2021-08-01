module Users
  class ArchiveManager

    def self.perform_operation(user_id:, current_user:, action:)
      actions = ['archived', 'unarchived']
      return nil if current_user.id == user_id.to_i || !actions.include?(action)
      user = User.find(user_id)
      user.update!(status: action)
      UserMailer.operation_performed(user_email: user.email, action: action).deliver_now
      UserOperation.create!(user_id: current_user.id, action: action[0..-2], user_modified: user.email)
      user
    end

  end
end