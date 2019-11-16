# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  it { should use_before_action(:authenticate_user) }

  it { should route(:get, 'organizations').to(action: :index) }
  it { should route(:post, 'organizations').to(action: :create) }
  it { should route(:get, 'organizations/id').to(action: :show, id: 'id') }
  it { should route(:patch, 'organizations/id').to(action: :update, id: 'id') }
end
