# frozen_string_literal: true

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
    let(:method) { :post }
    let(:url) { "/organizations/#{organization.id}/users" }
    let(:body) { { organization_user: { email: '' } } }

    before { post url, headers: auth_header(user), as: :json, params: body }

    it_behaves_like 'an authenticated request'

    context 'when the user is an authenticated employee' do
      let(:user) { create(:employee, organization: organization) }
      it_behaves_like 'a forbidden request'
    end

    context 'when the user is an authenticated admin' do
      context 'when the user to be added already exists' do
        let(:another_user) { create(:user) }
        let(:body) { { organization_user: { email: another_user.email, role: :employee } } }

        it 'creates the organization user' do
          expect(json['user']).to include(another_user.attributes.slice(%i[email name]))
          expect(json['organization_user']['role']).to eql(body[:organization_user][:role].to_s)
        end
      end

      context 'when the user to be added does not exist' do
        context 'when the body is incomplete for creating a new user' do
          it_behaves_like 'an unprocessable_entity request'
        end

        context 'when the body is complete for creating a new user' do
          let(:body) { { organization_user: { email: 'email@email.org', role: :employee, name: 'name', password: 'password' } } }

          it 'creates the user and organization user' do
            expect(json['user']).to include(body[:organization_user].slice(%i[email name]))
            expect(json['organization_user']['role']).to eql(body[:organization_user][:role].to_s)
          end
        end
      end
    end
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
