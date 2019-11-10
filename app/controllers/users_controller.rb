# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]

  def create
    @user = User.new(user_params)
    @user.email.downcase!

    @user.save!
  end

  def current
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
