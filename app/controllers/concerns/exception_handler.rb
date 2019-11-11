# frozen_string_literal: true

# ExceptionHandler
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from CanCan::AccessDenied do
      render json: { message: 'Access denied' }, status: :forbidden
    end

    rescue_from ActiveRecord::RecordNotFound do
      render json: { message: 'Record not found' }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      render json: { error: error.message }, status: :unprocessable_entity
    end

    rescue_from JWT::ExpiredSignature do
      render json: { message: 'Your token expired' }, status: :unauthorized
    end
  end
end
