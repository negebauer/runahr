# frozen_string_literal: true

# Root application
class ApplicationController < ActionController::API
  include ExceptionHandler
  include Knock::Authenticable

  private

  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end

  def set_current_user_as_user
    @user = current_user
  end
end
