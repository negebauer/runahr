# frozen_string_literal: true

user ||= nil

json.extract! attendance, :id, :created_at, :updated_at, :check_in_at, :check_out_at, :user_id
json.user_name user.name if user
