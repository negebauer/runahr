# frozen_string_literal: true

require_relative '../support/shared_examples.rb'

RSpec.describe 'OrganizationUsers requests' do
  let(:admin) { create(:admin) }
  let(:user) { admin }
  let(:organization) { create(:organization, user: admin, role: :admin) }

  describe 'GET /organizations/:organization_id/users' do
    let(:method) { :get }
    let(:url) { "/organizations/#{organization.id}/users" }

    it_behaves_like 'an authenticated request'

    context 'when the user is an authenticated employee' do
      let(:user) { create(:employee, organization: organization) }
      it_behaves_like 'a forbidden request'
    end

    context 'when the user is an authenticated admin' do
      before do
        create(:employee, organization: organization)
        get url, headers: auth_header(user), as: :json
      end

      it_behaves_like 'an ok request'

      it 'returns the list of organization users' do
        expect(json.count).to eql(2)
      end
    end
  end

  describe 'POST /organizations/:organization_id/users' do
    # TODO: More complex one
  end

  describe 'PATCH /organizations/:organization_id/users/:user_id' do
    let(:method) { :patch }
    let(:employee) { create(:employee, organization: organization) }
    let(:url) { "/organizations/#{organization.id}/users/#{employee.id}" }

    it_behaves_like 'an authenticated request'

    context 'when the user is an authenticated employee' do
      let(:user) { create(:employee, organization: organization) }
      it_behaves_like 'a forbidden request'
    end

    context 'when the user is an authenticated admin' do
      let(:body) { { organization_user: { role: :admin } } }

      before do
        patch url, headers: auth_header(user), as: :json, params: body
      end

      it_behaves_like 'an ok request'

      it 'changes the user role' do
        expect(json['role']).to eql(body[:organization_user][:role].to_s)
      end
    end
  end

  describe 'DELETE /organizations/:organization_id/users/:user_id' do
    let(:method) { :delete }
    let(:employee) { create(:employee, organization: organization) }
    let(:url) { "/organizations/#{organization.id}/users/#{employee.id}" }

    it_behaves_like 'an authenticated request'

    context 'when the user is an authenticated employee' do
      let(:user) { create(:employee, organization: organization) }
      it_behaves_like 'a forbidden request'
    end

    context 'when the user is an authenticated admin' do
      before { delete url, headers: auth_header(user), as: :json }

      it_behaves_like 'a no_content request'

      it 'removes the user from the organization' do
        expect(organization.users.count).to eql(1)
      end
    end
  end
end
