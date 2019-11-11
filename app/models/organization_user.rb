# frozen_string_literal: true

# OrganizationUser
class OrganizationUser < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :user_id, uniqueness: { scope: [:organization_id] }
  validates :role, presence: true

  enum role: %i[employee admin]

  before_validation do
    self.role ||= :employee
  end
end
