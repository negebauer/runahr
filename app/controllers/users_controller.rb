# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.email.downcase!

    @user.save!
    render json: @user, except: [:password_digest]
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
