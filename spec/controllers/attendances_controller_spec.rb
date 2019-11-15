# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do
  it { should use_before_action(:authenticate_user) }

  it {
    should route(:get, 'organizations/org_id/users/user_id/attendances').to(
      action: :user_attendances, organization_id: 'org_id', user_id: 'user_id'
    )
  }
  it {
    should route(:post, 'organizations/org_id/users/user_id/attendances/check_in').to(
      action: :user_check_in, organization_id: 'org_id', user_id: 'user_id'
    )
  }
  it {
    should route(:post, 'organizations/org_id/users/user_id/attendances/check_out').to(
      action: :user_check_out, organization_id: 'org_id', user_id: 'user_id'
    )
  }
  it { should route(:get, 'organizations/org_id/attendances/me').to(action: :me, organization_id: 'org_id') }
  it { should route(:post, 'organizations/org_id/attendances/check_in').to(action: :check_in, organization_id: 'org_id') }
  it { should route(:post, 'organizations/org_id/attendances/check_out').to(action: :check_out, organization_id: 'org_id') }
  it { should route(:get, 'organizations/org_id/attendances').to(action: :index, organization_id: 'org_id') }
  it { should route(:post, 'organizations/org_id/attendances').to(action: :create, organization_id: 'org_id') }
  it { should route(:patch, 'organizations/org_id/attendances/id').to(action: :update, organization_id: 'org_id', id: 'id') }
  it { should route(:delete, 'organizations/org_id/attendances/id').to(action: :destroy, organization_id: 'org_id', id: 'id') }
end
