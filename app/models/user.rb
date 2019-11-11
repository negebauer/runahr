# frozen_string_literal: true

# User
class User < ApplicationRecord
  has_secure_password
  has_many :organization_users
  has_many :organizations, through: :organization_users

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
end
