# frozen_string_literal: true

# OrganizationsController
class OrganizationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_current_user_as_user, only: %i[index show update]
  before_action :load_user_from_params, only: %i[user_attendances user_check_in user_check_out]

  load_and_authorize_resource only: %i[users add_user index show create update]

  def create
    @organization.organization_users.build(user: current_user, role: :admin)
    @organization.save!
    render status: :created
  end

  def update
    @organization.update(organization_params)
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

  private

  def organization_params
    params.require(:organization).permit(:name)
  end

  def load_user_from_params
    @user = User.find(params[:user_id])
  end
end
