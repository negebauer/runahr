# frozen_string_literal: true

# OrganizationUsersController
class OrganizationUsersController < ApplicationController
  before_action :authenticate_user

  load_and_authorize_resource :organization, id_param: 'organization_id'
  load_and_authorize_resource :organization_user,
                              find_by: :user_id,
                              id_param: 'user_id',
                              trough: :organization,
                              only: %i[index show update destroy]

  before_action :dont_allow_self_edit, only: %i[update destroy]

  def index
    user_ids = @organization_users.pluck(:user_id).uniq
    @users = User.where(id: user_ids).select(:id, :name).index_by(&:id)
  end

  def create
    email = organization_user_create_params[:email]
    return render json: { message: 'You must provide either a email' }, status: :bad_request unless email

    @user = User.find_by(email: email) || User.create(organization_user_create_params.permit!.except(:role))
    @organization_user = @organization.add_user(@user.id, organization_user_create_params[:role])
    @organization_user.save!
    render status: :created
  end

  def update
    @organization_user.update(params.require(:organization_user).permit(:role))
  end

  def destroy
    @organization_user.destroy!
    head :no_content
  end

  private

  def organization_user_create_params
    params.require(:organization_user).permit!
  end

  def dont_allow_self_edit
    user_id = params[:user_id].to_i
    email = params[:email]
    is_editing_self = current_user.id == user_id || current_user.email == email
    render json: { message: 'Cant modify your own role' }, status: :forbidden if is_editing_self
  end
end
