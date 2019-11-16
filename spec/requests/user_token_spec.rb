# frozen_string_literal: true

RSpec.describe 'UserToken requests' do
  describe 'POST /login' do
    let(:method) { :post }
    let(:url) { '/login' }
    let(:user) { create(:user) }
    let(:body) { { auth: { email: user.email, password: user.password } } }

    before { post url, as: :json, params: body }

    context 'when user auth is correct' do
      it_behaves_like 'a created request'

      it 'returns a jason web token' do
        expect(json['jwt']).not_to be_nil
      end
    end

    context 'when user auth is incorrect' do
      let(:body) { { auth: { email: user.email, password: 'bad-password' } } }

      it 'responds with not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
