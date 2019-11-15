# frozen_string_literal: true

# OrganizationsController
class OrganizationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_current_user_as_user, only: %i[index show update]

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

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
