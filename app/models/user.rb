# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

EMAIL_REGEX = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i.freeze

# User
class User < ApplicationRecord
  has_secure_password
  has_many :attendances, dependent: :destroy
  has_many :organization_users, dependent: :destroy
  has_many :organizations, through: :organization_users

  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: { allow_blank: true, case_sensitive: false },
                    format: { allow_blank: true, with: EMAIL_REGEX }
  validates :password_digest, presence: true

  before_save :downcase_email

  def downcase_email
    self.email = email.downcase
  end

  def organization_user(organization_id)
    organization_users.find_by(organization_id: organization_id)
  end

  def role(organization_id)
    organization_user(organization_id).role
  end

  def last_attendance(organization_id)
    attendances.where(organization_id: organization_id).order(check_in_at: :asc).last
  end

  def check_in(organization_id)
    attendance = last_attendance(organization_id)
    raise Exceptions::UserHasPendingCheckOut, attendance if attendance && !attendance.check_out_at?

    attendance = Attendance.new(user_id: id, organization_id: organization_id, check_in_at: DateTime.now)
    attendance.save!
    attendance
  end

  def check_out(organization_id)
    attendance = last_attendance(organization_id)
    raise Exceptions::UserHasNoCheckInToCheckOut if !attendance || attendance.check_out_at?

    attendance.check_out_at = DateTime.now
    attendance.save!
    attendance
  end
end
