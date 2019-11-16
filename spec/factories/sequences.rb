# frozen_string_literal: true

FactoryBot.define do
  sequence(:email) { |i| "user-email-#{i}@email.org" }
  sequence(:user_name) { |i| "user-name-#{i}" }
  sequence(:organization_name) { |i| "organization-name-#{i}" }
end
