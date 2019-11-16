# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationUsersController, type: :controller do
  it { should use_before_action(:authenticate_user) }

  it { should route(:get, 'organizations/org_id/users').to(action: :index, organization_id: 'org_id') }
  it { should route(:post, 'organizations/org_id/users').to(action: :create, organization_id: 'org_id') }
  it { should route(:get, 'organizations/org_id/users/id').to(action: :show, organization_id: 'org_id', user_id: 'id') }
  it { should route(:patch, 'organizations/org_id/users/id').to(action: :update, organization_id: 'org_id', user_id: 'id') }
  it { should route(:delete, 'organizations/org_id/users/id').to(action: :destroy, organization_id: 'org_id', user_id: 'id') }
end
