# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email
    name { generate(:user_name) }
    password { 'secret' }
  end
end
