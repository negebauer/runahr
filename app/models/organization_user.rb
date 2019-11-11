# frozen_string_literal: true

# OrganizationUser
class OrganizationUser < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :user_id, uniqueness: { scope: [:organization_id] }

  enum role: %i[employee admin]

  before_create do
    self.role ||= :employee if new_record?
  end
end
