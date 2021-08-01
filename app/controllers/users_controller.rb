# require_relative '../services/users/archive_manager'

class UsersController < ApplicationController
  include JSONAPI::Errors
  include JSONAPI::Deserialization

  def change_status
    status_change = status_params
    user = Users::ArchiveManager.perform_operation(action: status_change[:status],
                                                   user_id: status_change[:user_id],
                                                   current_user: @user)
    if user.nil?
      render json: { error: 'unauthorized action' }, status: :unauthorized
    else
      render jsonapi: user, status: 200
    end
  end

  def index
    status = filter_params
    case status
    when 'archived'
      render jsonapi: User.where(status: status)
    when 'unarchived'
      render jsonapi: User.where(status: status)
    else
      render jsonapi: User.all
    end
  end

  private
  def status_params
    jsonapi_deserialize(params, only: [:status, :user_id]).symbolize_keys
  end

  def filter_params
    params.require(:status)
  end

end
