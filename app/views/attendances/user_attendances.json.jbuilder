# frozen_string_literal: true

json.array! @attendances, partial: 'attendance', as: :attendance
