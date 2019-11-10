# frozen_string_literal: true

# Root application
class ApplicationController < ActionController::API
  include Knock::Authenticable
end
