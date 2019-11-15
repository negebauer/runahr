# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:organization_users).dependent(:destroy) }
    it { should have_many(:organizations).through(:organization_users) }
    it { should have_many(:attendances).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should have_secure_password }
    it { should validate_presence_of(:password_digest) }

    describe 'email' do
      subject { create(:user) }

      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email).case_insensitive }
      it { should allow_values('user-email@email.org').for(:email) }

      it { should_not allow_values('', 'user-email', 'u@', 'u@exa', 'u@exa').for(:email) }
    end

    describe 'attributes' do
      describe 'email' do
        it 'is downcased on save' do
          user = create(:user, email: 'User-email@EmaiL.oRg')
          expect(user.email).to eql('user-email@email.org')
          user.update!(email: 'another-Email@EmaiL.oRg')
          expect(user.email).to eql('another-email@email.org')
        end
      end
    end

    describe '#check_in!' do
      %i[employee admin].each do |role|
        context "when the user has role #{role}" do
          subject { create(role) }
          let(:organization) { subject.organizations.first }

          context 'when the user has no pending check out' do
            let(:attendance) { subject.check_in!(organization.id) }

            it 'creates an attendance with check_in_at and no check_out_at' do
              expect(attendance.check_in_at).not_to be_nil
              expect(attendance.check_out_at).to be_nil
            end
          end

          context 'when the user has a pending check out' do
            let(:attendance) { subject.check_in!(organization.id) }
            let(:attendance2) { subject.check_in!(organization.id) }

            it 'throws a UserHasPendingCheckOut error' do
              expect { attendance }.not_to raise_error
              expect { attendance2 }.to raise_error(Exceptions::UserHasPendingCheckOut)
            end
          end
        end
      end
    end

    describe '#check_out!' do
      %i[employee admin].each do |role|
        context "when the user has role #{role}" do
          let(:organization) { create(:organization) }
          subject { create(role, organization: organization) }

          context 'when the user has no pending check out' do
            let(:attendance) { subject.check_out!(organization.id) }

            it 'throws a UserHasNoCheckInToCheckOut error' do
              expect { attendance }.to raise_error(Exceptions::UserHasNoCheckInToCheckOut)
            end
          end

          context 'when the user has a pending check out' do
            let(:attendance) do
              subject.check_in!(organization.id)
              subject.check_out!(organization.id)
            end

            it 'returns an attendance with check_in_at and check_out_at' do
              expect(attendance.check_in_at).not_to be_nil
              expect(attendance.check_out_at).not_to be_nil
            end
          end
        end
      end
    end
  end
end
