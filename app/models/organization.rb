# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :organization_users
  has_many :users, through: :organization_users

  validates :name, presence: true, uniqueness: true
end
