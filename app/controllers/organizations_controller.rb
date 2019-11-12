# frozen_string_literal: true

# OrganizationsController
class OrganizationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_current_user_as_user, only: %i[index show check_in check_out]
  before_action :load_user_from_params, only: %i[user_check_in user_check_out]

  load_and_authorize_resource id_param: 'organization_id', only: %i[check_in check_out user_check_in user_check_out]
  load_and_authorize_resource only: %i[users add_user show create]

  def create
    @organization.organization_users.build(user: current_user, role: :admin)
    @organization.save!
    render status: :created
  end

  def users
    @users = @organization.users
  end

  def add_user
    user_id = params[:user_id].to_i
    return render json: { message: 'Cant change your own role' }, status: :forbidden if current_user.id == user_id

    @organization_user = @organization.add_user(user_id, params[:role])
    @organization_user.save!
  end

  def check_in
    perform_check_in
  end

  def check_out
    perform_check_out
  end

  def user_check_in
    perform_check_in
  end

  def user_check_out
    perform_check_out
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end

  def load_user_from_params
    @user = User.find(params[:user_id])
  end

  def perform_check_in
    @attendance = @user.check_in(@organization.id)
  rescue Exceptions::UserHasPendingCheckOut => e
    render json: {
      message: 'User has a pending check out',
      attendance: { id: e.attendance.id, check_in_at: e.attendance.check_in_at }
    }, status: :unprocessable_entity
  end

  def perform_check_out
    @attendance = @user.check_out(@organization.id)
  rescue Exceptions::UserHasNoCheckInToCheckOut
    render json: { message: 'User does not have a check in with a pending check out' }, status: :unprocessable_entity
  end
end
