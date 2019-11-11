# frozen_string_literal: true

# User
class User < ApplicationRecord
  has_secure_password
  has_many :organization_users
  has_many :organizations, through: :organization_users

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  def organization_user(organization_id)
    OrganizationUser.find_by(user_id: id, organization_id: organization_id)
  end

  def role(organization_id)
    organization_user(organization_id).role
  end
end
