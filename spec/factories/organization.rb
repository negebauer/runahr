# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { generate(:organization_name) }

    transient do
      admin_count { 0 }
      employee_count { 0 }
    end

    after(:create) do |organization, options|
      options.admin_count&.times do
        create(:admin, organization: organization)
      end

      options.employee_count&.times do
        create(:employee, organization: organization)
      end
    end
  end
end
