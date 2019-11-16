# frozen_string_literal: true

# == Schema Information
#
# Table name: organization_users
#
#  id              :bigint           not null, primary key
#  user_id         :bigint
#  organization_id :bigint
#  role            :integer
#

# OrganizationUser
class OrganizationUser < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :user_id, presence: true, uniqueness: { allow_blank: true, scope: [:organization_id] }
  validates :organization_id, presence: true
  validates :role, presence: true

  enum role: %i[employee admin]

  before_validation do
    self.role ||= :employee
  end
end
