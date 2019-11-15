# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string
#

class Organization < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :organization_users, dependent: :destroy
  has_many :users, through: :organization_users

  validates :name, presence: true, uniqueness: true
end
