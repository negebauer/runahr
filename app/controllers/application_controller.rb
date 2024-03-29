# frozen_string_literal: true

# Root application
class ApplicationController < ActionController::API
  include ExceptionHandler
  include Knock::Authenticable

  private

  def set_current_user_as_user
    @user = current_user
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, @organization)
  end
end
