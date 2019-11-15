# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email
    name { generate(:user_name) }
    password { 'secret' }

    transient do
      organization { nil }
    end

    factory :employee do
      after(:create) do |user, options|
        organization = options[:organization]
        organization ||= create(:organization)
        create(:organization_user, user_id: user.id, organization_id: organization.id, role: :employee)
      end
    end

    factory :admin do
      after(:create) do |user, options|
        organization = options[:organization]
        organization ||= create(:organization)
        create(:organization_user, user_id: user.id, organization_id: organization.id, role: :admin)
      end
    end
  end
end
