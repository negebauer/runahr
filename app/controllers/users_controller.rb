# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  def create
    puts 'HOLA'
    puts user_params
    @user = User.new(user_params)
    puts @user
    @user.email.downcase!

    @user.save!
    render json: @user, except: [:password_digest]
  end

  private

  def user_params
    puts params
    params.permit(:name, :email, :password)
  end
end
