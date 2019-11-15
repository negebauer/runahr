# frozen_string_literal: true

# OrganizationUsersController
class OrganizationUsersController < ApplicationController
  before_action :authenticate_user

  load_and_authorize_resource id_param: 'organization_id'

  def index
    # todo
  end

  def create
    # todo
  end
end
