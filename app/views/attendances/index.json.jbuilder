# frozen_string_literal: true

json.array! @attendances do |attendance|
  json.partial! 'attendance', attendance: attendance, user: @users[attendance.user_id]
end
