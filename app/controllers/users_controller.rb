# require_relative '../services/users/archive_manager'

class UsersController < ApplicationController
  include JSONAPI::Errors
  include JSONAPI::Deserialization

  # Change the +status+ of the specified user +user_id+
  # @return the user if the status was successfully updated or an exception
  # in any other case.
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

  # List the users based in the +status+ desired
  # @return the users filtering by archived or unarchived if any og those are
  # provided, then returns the full list of users
  # @todo add pagination here
  def index
    status = filter_params
    users = status == 'archived' || status == 'unarchived' ?
              User.where(status: status) : User.all

    render jsonapi: users
  end

  private
  def status_params
    jsonapi_deserialize(params, only: [:status, :user_id]).symbolize_keys
  end

  def filter_params
    params.require(:status)
  end

end
