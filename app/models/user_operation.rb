class UserOperation < ApplicationRecord
  belongs_to :user
  enum action: [:archive, :unarchive]
end
