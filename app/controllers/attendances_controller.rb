# frozen_string_literal: true

# AttendancesController
class AttendancesController < ApplicationController
  before_action :authenticate_user
  before_action :set_current_user_as_user, only: %i[index]

  load_and_authorize_resource :organization, id_param: 'organization_id', only: %i[index me]
  load_and_authorize_resource :attendance, trough: :organization, only: %i[index me]

  def index
    user_ids = @attendances.pluck(:user_id).uniq
    @users = User.where(id: user_ids).select(:id, :name).index_by(&:id)
  end
end
