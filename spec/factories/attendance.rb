# frozen_string_literal: true

FactoryBot.define do
  factory :attendance do
    user_id { create(:user).id }
    organization_id { create(:organization).id }
    check_in_at { DateTime.now }
    check_out_at { nil }
  end
end
