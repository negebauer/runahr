# frozen_string_literal: true

json.array! @attendances do |attendance|
  json.partial! 'attendance', attendance: attendance, user_name: @users[attendance.user_id].name
end