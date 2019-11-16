# frozen_string_literal: true

# == Schema Information
#
# Table name: attendances
#
#  id              :bigint           not null, primary key
#  user_id         :bigint
#  organization_id :bigint
#  check_in_at     :datetime
#  check_out_at    :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Attendance, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:organization) }
  end

  describe 'validations' do
    it { should validate_presence_of(:check_in_at) }

    describe 'check_out_at > check_in_at' do
      let(:attendance) { create(:attendance) }

      it 'validates that check_out_at is smaller than check_in_at' do
        attendance.check_in_at = DateTime.now
        attendance.check_out_at = attendance.check_in_at - 1
        expect(attendance).to be_invalid
      end
    end
  end
end
