# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]

  load_and_authorize_resource

  def create
    @user.email.downcase!
    @user.save!
  end

  def me
    @user = current_user
  end

  def organizations
    @organizations = current_user.organizations
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
