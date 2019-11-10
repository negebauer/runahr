# frozen_string_literal: true

# User
class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  enum role: { employee: 0, admin: 1 }

  after_initialize :set_defaults

  private

  def set_defaults
    self.role ||= :employee if new_record?
  end
end
