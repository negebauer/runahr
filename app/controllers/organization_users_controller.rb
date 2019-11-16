# frozen_string_literal: true

# OrganizationUsersController
class OrganizationUsersController < ApplicationController
  before_action :authenticate_user

  load_and_authorize_resource :organization, id_param: 'organization_id'
  before_action :load_organization_user, only: %i[show update destroy]
  authorize_resource :organization_user,
                     only: %i[show update destroy]

  before_action :dont_allow_self_create, only: %i[create]
  before_action :dont_allow_self_update_or_destroy, only: %i[update destroy]

  def index
    @organization_users = @organization.organization_users.accessible_by(current_ability)
    authorize! :read, @organization_users
    user_ids = @organization_users.pluck(:user_id).uniq
    @users = User.where(id: user_ids).select(:id, :name).index_by(&:id)
  end

  def create # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    email = organization_user_params[:email]
    return render json: { message: 'You must provide either a email' }, status: :bad_request unless email

    @user = User.find_by(email: email) || User.create(organization_user_params.permit!.except(:role))
    @organization_user = @organization.organization_users.find_by(user_id: @user.id)
    if @organization_user
      @message = 'The organization user already exists'
      return render status: :unprocessable_entity
    end

    @organization_user = @organization.organization_users.new(user_id: @user.id, role: organization_user_params[:role])
    @organization_user.save!
    render status: :created
  end

  def update
    @organization_user.update!(params.require(:organization_user).permit(:role))
  end

  def destroy
    @organization_user.destroy!
    head :no_content
  end

  private

  def organization_user_params
    params.require(:organization_user).permit!
  end

  def load_organization_user
    @organization_user = @organization.organization_users.find_by(user_id: params[:user_id])
  end

  def dont_allow_self_create
    user_id = organization_user_params[:user_id].to_i
    email = organization_user_params[:user_email]
    is_editing_self = current_user.id == user_id || current_user.email == email
    render json: { message: 'Cant modify your own role' }, status: :forbidden if is_editing_self
  end

  def dont_allow_self_update_or_destroy
    user_id = params[:user_id].to_i
    render json: { message: 'Cant modify your own role' }, status: :forbidden if current_user.id == user_id
  end
end
