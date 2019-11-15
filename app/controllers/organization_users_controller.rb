# frozen_string_literal: true

# OrganizationUsersController
class OrganizationUsersController < ApplicationController
  before_action :authenticate_user

  load_and_authorize_resource :organization, id_param: 'organization_id'
  load_and_authorize_resource :organization_user,
                              trough: :organization,
                              only: %i[index show create update destroy]

  def index
    user_ids = @organization_users.pluck(:user_id).uniq
    @users = User.where(id: user_ids).select(:id, :name).index_by(&:id)
  end

  def create
    # todo
  end
end
