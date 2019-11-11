# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]
  before_action :set_current_user_as_user, only: [:me]

  load_and_authorize_resource

  def create
    @user.email&.downcase!
    @user.save!
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
