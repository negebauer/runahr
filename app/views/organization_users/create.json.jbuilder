# frozen_string_literal: true

json.user do
  json.partial! 'users/user', user: @user
end

json.organization_user do
  json.partial! 'organization_user', organization_user: @organization_user
end

json.message @message if @message
