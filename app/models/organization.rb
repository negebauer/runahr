# frozen_string_literal: true

class Organization < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, presence: true, uniqueness: true
end
