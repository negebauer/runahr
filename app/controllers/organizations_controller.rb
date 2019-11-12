# frozen_string_literal: true

# OrganizationsController
class OrganizationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_current_user_as_user, only: %i[index show check_in check_out]

  load_and_authorize_resource id_param: 'organization_id', except: :show
  load_and_authorize_resource only: :show

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
    @user.check_in(@organization.id)
    head :ok
  end

  def check_out
    @attendance = @user.check_out(@organization.id)
    render json: @attendance
  rescue Exceptions::UserHasNoCheckInToCheckOut
    render json: { message: 'User does not have a check in with a pending check out' }, status: :unprocessable_entity
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
