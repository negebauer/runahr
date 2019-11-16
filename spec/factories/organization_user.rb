# frozen_string_literal: true

FactoryBot.define do
  factory :organization_user do
    user_id { create(:user).id }
    organization_id { create(:organization).id }
    role { :employee }
  end
end
