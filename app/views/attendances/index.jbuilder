# frozen_string_literal: true

json.array! @user_attendances do |user_attendance|
  json.attendances do
    json.array! user_attendance[:attendances], partial: 'attendance', as: :attendance
  end

  json.user do
    json.partial! 'users/user', user: user_attendance[:user]
  end
end
