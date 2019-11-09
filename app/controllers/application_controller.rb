# frozen_string_literal: true

# Root application
class ApplicationController < ActionController::API
  include Knock::Authenticable

  def root
    render json: { active: true, datetime: DateTime.new }
  end
end
