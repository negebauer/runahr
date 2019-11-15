# frozen_string_literal: true

json.array! @organization_users do |organization_user|
  json.partial! 'organization_user', organization_user: organization_user, user: @users[organization_user.user_id]
end
