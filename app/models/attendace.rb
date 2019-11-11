# frozen_string_literal: true

# Attendance
class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :organization
end
