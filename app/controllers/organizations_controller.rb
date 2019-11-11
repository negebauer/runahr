# frozen_string_literal: true

# OrganizationsController
class OrganizationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_current_user_as_user, only: %i[index show]

  load_and_authorize_resource

  def create
    @organization.organization_users.build(user: current_user, role: :admin)
    @organization.save!
    render status: :created
  end

  def users
    @users = @organization.users
  end

  def add_user
    @organization_user = @organization.add_user(params[:user_id], params[:role])
    @organization_user.save!
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
