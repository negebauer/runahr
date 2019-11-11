# frozen_string_literal: true

# User
class User < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :organizations

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  enum role: %i[org_employee org_admin]

  before_create do
    self.role ||= :org_employee if new_record?
  end
end
