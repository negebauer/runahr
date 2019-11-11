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

  def add_user
    user_id = params[:user_id]
    role = params[:role] || :employee
    @organization_user = @organization.organization_users.find_by(user_id: user_id)
    @organization_user ||= @organization.organization_users.new(user_id: user_id)
    @organization_user.role = role
    @organization_user.save!
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
