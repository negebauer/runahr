# frozen_string_literal: true

json.attendance do
  json.partial! 'attendance', attendance: @attendance
end

json.user do
  json.partial! 'users/user', user: @user
end
