# frozen_string_literal: true

require_relative '../support/shared_examples.rb'

RSpec.describe 'Users requests' do
  describe 'GET /users/me' do
    let(:method) { :get }
    let(:url) { '/users/me' }
    let(:user) { create(:user) }

    it_behaves_like 'an authenticated request'

    context 'when the user is authenticated' do
      before do
        get url, headers: auth_header(user), as: :json
      end

      it_behaves_like 'an ok request'

      it 'returns the user data' do
        expect(json).to include(user.attributes.slice(%i[name email id]))
      end
    end
  end

  describe 'POST /users' do
    let(:method) { :post }
    let(:url) { '/users' }
    let(:body) { { user: { name: 'user-name', password: 'password', email: 'user-email@email.org' } } }

    before { post url, as: :json, params: body }

    context 'when body is valid' do
      it_behaves_like 'a created request'

      it 'returns the user data' do
        expect(json).to include(body[:user].slice(%i[name email]))
      end
    end

    context 'when email is invalid' do
      let(:body) { { user: { name: 'user-name', password: 'password', email: 'bad-email' } } }

      it 'responds with unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
