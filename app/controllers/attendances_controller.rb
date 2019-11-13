# frozen_string_literal: true

# AttendancesController
class AttendancesController < ApplicationController
  before_action :authenticate_user
  before_action :set_current_user_as_user, only: %i[index]

  load_and_authorize_resource :organization, id_param: 'organization_id', only: %i[index me]
  load_and_authorize_resource :attendance, trough: :organization, only: %i[index me]

  def index
    @user_attendances = @attendances.group_by(&:user_id).map do |user_id, attendances|
      {
        user: User.find_by(id: user_id),
        attendances: attendances
      }
    end
  end
end
