# frozen_string_literal: true

# AttendancesController
class AttendancesController < ApplicationController
  before_action :authenticate_user
  before_action :set_current_user_as_user, only: %i[check_in check_out]

  load_and_authorize_resource :organization, id_param: 'organization_id'
  load_and_authorize_resource :attendance, trough: :organization, except: %i[check_in check_out]

  before_action :load_attendance_user, only: %i[create update]

  def index
    user_ids = @attendances.pluck(:user_id).uniq
    @users = User.where(id: user_ids).select(:id, :name).index_by(&:id)
  end

  def create
    @attendance.save!
    render status: :created
  end

  def update
    @attendance.update(attendance_params)
  end

  def destroy
    @attendance.destroy!
    head :no_content
  end

  def check_in
    perform_check_in
  end

  def check_out
    perform_check_out
  end

  private

  def load_attendance_user
    @user = @attendance.user
  end

  def attendance_params
    params.require(:attendance).permit(:check_in_at, :check_out_at, :user_id)
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
