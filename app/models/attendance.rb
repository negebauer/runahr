# frozen_string_literal: true

# Attendance
class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :check_in_at, presence: true
  validate :check_out_at_must_be_greater_than_check_in_at

  def check_out_at_must_be_greater_than_check_in_at
    puts 'ASD'
    puts check_in_at
    puts check_out_at
    puts check_out_at < check_in_at
    return unless check_out_at.present?

    puts 'ASD'

    errors.add(:check_out_at, "must be greater than #{check_in_at}") if check_out_at < check_in_at
    puts 'errors'
    puts errors
  end
end
