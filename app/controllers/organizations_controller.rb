# frozen_string_literal: true

# OrganizationsController
class OrganizationsController < ApplicationController
  before_action :authenticate_user

  load_and_authorize_resource

  def index
    @organizations = Organization.all
  end

  def show; end

  def create
    @organization.save!
  end

  def update
    if @organization.update(organization_params)
      render :show, status: :ok, location: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
