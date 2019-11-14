# frozen_string_literal: true

# AttendancesController
class AttendancesController < ApplicationController
  before_action :authenticate_user

  load_and_authorize_resource :organization, id_param: 'organization_id'
  load_and_authorize_resource :attendance, trough: :organization

  before_action :load_attendance_user_name, except: [:index]

  def index
    user_ids = @attendances.pluck(:user_id).uniq
    @users = User.where(id: user_ids).select(:id, :name).index_by(&:id)
  end

  def update
    @attendance.update(attendance_params)
  end

  private

  def load_attendance_user_name
    @user_name = @attendance.user.name
  end

  def attendance_params
    params.require(:attendance).permit(:check_in_at, :check_out_at, :user_id)
  end
end
