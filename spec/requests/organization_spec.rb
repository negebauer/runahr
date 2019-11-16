# frozen_string_literal: true

RSpec.describe 'Organizations requests' do
  let(:user) { create(:user) }

  describe 'GET /organizations' do
    let(:method) { :get }
    let(:url) { '/organizations' }

    it_behaves_like 'an authenticated request'

    context 'when the user is authenticated' do
      before do
        create(:organization, user: user, role: :admin)
        create(:organization, user: user, role: :employee)
        get url, headers: auth_header(user), as: :json
      end

      it_behaves_like 'an ok request'

      it 'returns the organizations of the user' do
        expect(json.count).to eql(2)
      end
    end
  end

  describe 'POST /organizations' do
    let(:method) { :post }
    let(:url) { '/organizations' }
    let(:body) { { name: 'organization' } }

    it_behaves_like 'an authenticated request'

    context 'when the user is authenticated' do
      before do
        post url, headers: auth_header(user), as: :json, params: body
      end

      it_behaves_like 'a created request'

      it 'returns the new organization' do
        expect(json['name']).to eql(body[:name])
      end
    end
  end

  describe 'GET /organizations/:organization_id' do
    let(:method) { :get }
    let(:organization) { create(:organization, user: user, role: :employee) }
    let(:url) { "/organizations/#{organization.id}" }

    it_behaves_like 'an authenticated request'

    context 'when the user is authenticated' do
      %i[employee admin].each do |role_name|
        context "when the user has role #{role_name}" do
          before do
            get url, headers: auth_header(user), as: :json
          end

          it_behaves_like 'an ok request'

          it 'returns the organization' do
            expect(json['name']).to eql(organization.name)
          end
        end
      end
    end
  end

  describe 'PATH /organizations/:organization_id' do
    let(:method) { :patch }
    let(:role) { :employee }
    let(:organization) { create(:organization, user: user, role: role) }
    let(:url) { "/organizations/#{organization.id}" }

    it_behaves_like 'an authenticated request'

    context 'when the user has role employee' do
      it_behaves_like 'a forbidden request'
    end

    context 'when the user has role admin' do
      let(:role) { :admin }
      let(:body) { { name: 'new-organization-name' } }

      before do
        patch url, headers: auth_header(user), as: :json, params: body
      end

      it 'updates the name' do
        expect(json['name']).to eql(body[:name])
      end
    end
  end
end
