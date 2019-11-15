# frozen_string_literal: true

# == Schema Information
#
# Table name: attendances
#
#  id              :bigint           not null, primary key
#  user_id         :bigint
#  organization_id :bigint
#  check_in_at     :datetime
#  check_out_at    :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# Attendance
class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :check_in_at, presence: true
  validate :check_out_at_must_be_greater_than_check_in_at

  def check_out_at_must_be_greater_than_check_in_at
    return unless check_out_at.present?

    errors.add(:check_out_at, "must be greater than #{check_in_at}") if check_out_at < check_in_at
  end
end
