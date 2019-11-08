# frozen_string_literal: true

# Root application
class ApplicationController < ActionController::API
  def root
    render json: { active: true, datetime: DateTime.new }
  end
end
