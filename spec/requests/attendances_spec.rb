# frozen_string_literal: true

RSpec.describe 'Attendance requests' do
  let(:organization) { create(:organization) }
  let(:admin) { create(:admin, organization: organization) }
  let(:employee) { create(:employee, organization: organization) }
  let(:user) { admin }

  describe 'GET /organizations/:organization_id/attendances' do
    let(:method) { :get }
    let(:url) { "/organizations/#{organization.id}/attendances" }

    it_behaves_like 'an authenticated request'

    context 'when the user is an authenticated employee' do
      let(:user) { employee }
      it_behaves_like 'a forbidden request'
    end

    context 'when the user is an authenticated admin' do
      before do
        create(:attendance, user_id: user.id, organization_id: organization.id)
        create(:attendance, user_id: employee.id, organization_id: organization.id)
        get url, headers: auth_header(user), as: :json
      end

      it_behaves_like 'an ok request'

      it 'returns the list of attendances of the organization' do
        expect(json.count).to eql(2)
        json.each do |attendance|
          expect(attendance['check_in_at']).not_to be_nil
          expect(attendance['check_out_at']).to be_nil
        end
      end
    end
  end

  describe 'POST /organizations/:organization_id/attendances' do
    let(:method) { :post }
    let(:url) { "/organizations/#{organization.id}/attendances" }
    let(:body) { { attendance: { user_id: employee.id, check_in_at: DateTime.now, check_out_at: DateTime.now + 1 } } }

    it_behaves_like 'an authenticated request'

    context 'when the user is an authenticated employee' do
      let(:user) { employee }
      it_behaves_like 'a forbidden request'
    end

    context 'when the user is an authenticated admin' do
      before { post url, headers: auth_header(user), as: :json, params: body }

      context 'when the body is valid' do
        it_behaves_like 'a created request'

        it 'creates the attendance' do
          expect(json['user_id']).to eql(body[:attendance][:user_id])
          expect(DateTime.parse(json['check_in_at']).utc.to_s).to eql(body[:attendance][:check_in_at].utc.to_s)
          expect(DateTime.parse(json['check_out_at']).utc.to_s).to eql(body[:attendance][:check_out_at].utc.to_s)
        end
      end

      context 'when check_out_at is not in the body' do
        let(:body) { { attendance: { user_id: employee.id, check_in_at: DateTime.now } } }

        it_behaves_like 'an unprocessable_entity request'
      end

      context 'when check_out_at is before check_in_at' do
        let(:now) { DateTime.now }
        let(:body) { { attendance: { user_id: employee.id, check_in_at: now, check_out_at: now - 1 } } }

        it_behaves_like 'an unprocessable_entity request'
      end
    end
  end

  describe 'GET /organizations/:organization_id/attendances/id' do
    let(:method) { :get }
    let(:attendance) { create(:attendance, user_id: employee.id, organization_id: organization.id) }
    let(:url) { "/organizations/#{organization.id}/attendances/#{attendance.id}" }

    it_behaves_like 'an authenticated request'

    context 'when the user is an authenticated employee' do
      let(:user) { employee }
      it_behaves_like 'a forbidden request'
    end

    context 'when the user is an authenticated admin' do
      before { get url, headers: auth_header(user), as: :json }

      it_behaves_like 'an ok request'

      it 'returns the attendance' do
        expect(json['user_id']).to eql(attendance.user_id)
        expect(DateTime.parse(json['check_in_at']).utc.to_s).to eql(attendance.check_in_at.utc.to_s)
      end
    end
  end

  describe 'PATCH /organizations/:organization_id/attendances/id' do
    let(:method) { :patch }
    let(:attendance) { create(:attendance, user_id: employee.id, organization_id: organization.id) }
    let(:url) { "/organizations/#{organization.id}/attendances/#{attendance.id}" }
    let(:body) { { attendance: { check_out_at: DateTime.now } } }

    it_behaves_like 'an authenticated request'

    context 'when the user is an authenticated employee' do
      let(:user) { employee }
      it_behaves_like 'a forbidden request'
    end

    context 'when the user is an authenticated admin' do
      before { patch url, headers: auth_header(user), as: :json, params: body }

      context 'when the body is valid' do
        it_behaves_like 'an ok request'

        it 'returns the modified attendance' do
          expect(json['user_id']).to eql(attendance.user_id)
          expect(DateTime.parse(json['check_out_at']).utc.to_s).to eql(body[:attendance][:check_out_at].utc.to_s)
        end
      end

      context 'when check_out_at is before check_in_at' do
        let(:now) { DateTime.now }
        let(:body) { { attendance: { check_in_at: now, check_out_at: now - 1 } } }

        it_behaves_like 'an unprocessable_entity request'
      end
    end
  end

  describe 'DELETE /organizations/:organization_id/attendances/id' do
    let(:method) { :delete }
    let(:attendance) { create(:attendance, user_id: employee.id, organization_id: organization.id) }
    let(:url) { "/organizations/#{organization.id}/attendances/#{attendance.id}" }

    it_behaves_like 'an authenticated request'

    context 'when the user is an authenticated employee' do
      let(:user) { employee }
      it_behaves_like 'a forbidden request'
    end

    context 'when the user is an authenticated admin' do
      before { delete url, headers: auth_header(user), as: :json }

      it_behaves_like 'a no_content request'

      it 'deletes the attendance' do
        expect(organization.attendances.count).to eql(0)
      end
    end
  end

  describe 'GET /organizations/:organization_id/attendances/me' do
    let(:method) { :get }
    let(:url) { "/organizations/#{organization.id}/attendances/me" }

    it_behaves_like 'an authenticated request'

    context 'when the user is authenticated' do
      %i[employee admin].each do |role|
        context "when the user has role #{role}" do
          before do
            user = create(role, organization: organization)
            create(:attendance, user_id: user.id, organization_id: organization.id)
            get url, headers: auth_header(user), as: :json
          end

          it_behaves_like 'an ok request'

          it 'returns the attendances of the user' do
            expect(json.count).to eql(1)
          end
        end
      end
    end
  end

  describe 'POST /organizations/:organization_id/attendances/check_in' do
    let(:method) { :post }
    let(:url) { "/organizations/#{organization.id}/attendances/check_in" }

    it_behaves_like 'an authenticated request'

    context 'when the user is authenticated' do
      %i[employee admin].each do |role|
        context "when the user has role #{role}" do
          let(:user) { create(role, organization: organization) }

          context 'when user has no pending check out' do
            before { post url, headers: auth_header(user), as: :json }

            it_behaves_like 'an ok request'

            it 'returns the created attendance' do
              expect(json['check_in_at']).not_to be_nil
              expect(json['check_out_at']).to be_nil
            end
          end

          context 'when user has a pending check out' do
            before do
              create(:attendance, user_id: user.id, organization_id: organization.id)
              post url, headers: auth_header(user), as: :json
            end

            it_behaves_like 'an unprocessable_entity request'
          end
        end
      end
    end
  end

  describe 'POST /organizations/:organization_id/attendances/check_out' do
    let(:method) { :post }
    let(:url) { "/organizations/#{organization.id}/attendances/check_out" }

    it_behaves_like 'an authenticated request'

    context 'when the user is authenticated' do
      %i[employee admin].each do |role|
        context "when the user has role #{role}" do
          let(:user) { create(role, organization: organization) }

          context 'when user has no pending check out' do
            before { post url, headers: auth_header(user), as: :json }

            it_behaves_like 'an unprocessable_entity request'
          end

          context 'when user has a pending check out' do
            before do
              create(:attendance, user_id: user.id, organization_id: organization.id)
              post url, headers: auth_header(user), as: :json
            end

            it_behaves_like 'an ok request'

            it 'returns the created attendance' do
              expect(json['check_in_at']).not_to be_nil
              expect(json['check_out_at']).not_to be_nil
            end
          end
        end
      end
    end
  end

  describe 'GET /organizations/:organization_id/users/:user_id/attendances' do
    let(:method) { :get }
    let(:url) { "/organizations/#{organization.id}/users/#{employee.id}/attendances" }

    it_behaves_like 'an authenticated request'

    context 'when the user is an authenticated employee' do
      let(:user) { employee }
      it_behaves_like 'a forbidden request'
    end

    context 'when the user is an authenticated admin' do
      before do
        create(:attendance, user_id: employee.id, organization_id: organization.id)
        get url, headers: auth_header(user), as: :json
      end

      it_behaves_like 'an ok request'

      it 'returns the list of attendances of the organization' do
        expect(json.count).to eql(1)
        json.each do |attendance|
          expect(attendance['check_in_at']).not_to be_nil
          expect(attendance['check_out_at']).to be_nil
        end
      end
    end
  end

  describe 'POST /organizations/:organization_id/users/:user_id/attendances/check_in' do
    let(:method) { :post }
    let(:url) { "/organizations/#{organization.id}/users/#{employee.id}/attendances/check_in" }

    it_behaves_like 'an authenticated request'

    context 'when the user is an authenticated employee' do
      let(:user) { employee }
      it_behaves_like 'a forbidden request'
    end

    context 'when the user is an authenticated admin' do
      before { post url, headers: auth_header(user), as: :json }

      context 'when user has no pending check out' do
        it_behaves_like 'an ok request'

        it 'returns the created attendance' do
          expect(json['check_in_at']).not_to be_nil
          expect(json['check_out_at']).to be_nil
        end
      end

      context 'when user has a pending check out' do
        before { create(:attendance, user_id: employee.id, organization_id: organization.id) }

        it_behaves_like 'an unprocessable_entity request'
      end
    end
  end

  describe 'POST /organizations/:organization_id/users/:user_id/attendances/check_out' do
    let(:method) { :post }
    let(:url) { "/organizations/#{organization.id}/users/#{employee.id}/attendances/check_out" }

    it_behaves_like 'an authenticated request'

    context 'when the user is an authenticated employee' do
      let(:user) { employee }
      it_behaves_like 'a forbidden request'
    end

    context 'when the user is an authenticated admin' do
      before { post url, headers: auth_header(user), as: :json }

      context 'when user has no pending check out' do
        before { post url, headers: auth_header(user), as: :json }

        it_behaves_like 'an unprocessable_entity request'
      end

      context 'when user has a pending check out' do
        before do
          create(:attendance, user_id: employee.id, organization_id: organization.id)
          post url, headers: auth_header(user), as: :json
        end

        it_behaves_like 'an ok request'

        it 'returns the created attendance' do
          expect(json['check_in_at']).not_to be_nil
          expect(json['check_out_at']).not_to be_nil
        end
      end
    end
  end
end
