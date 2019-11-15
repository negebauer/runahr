# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { generate(:organization_name) }
    user_id { create(:user).id }
    organization_id { create(:organization).id }
    role { :employee }
  end
end
