# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :attendances
  has_many :organization_users
  has_many :users, through: :organization_users

  validates :name, presence: true, uniqueness: true

  def add_user(user_id, role)
    organization_user = organization_users.find_by(user_id: user_id)
    organization_user ||= organization_users.new(user_id: user_id)
    organization_user.role = role
    organization_user
  end
end
