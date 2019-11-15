# frozen_string_literal: true

user ||= nil

json.extract! organization_user, :organization_id, :role, :user_id
json.user_name user.name if user
