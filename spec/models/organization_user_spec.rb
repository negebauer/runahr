# frozen_string_literal: true

# == Schema Information
#
# Table name: organization_users
#
#  id              :bigint           not null, primary key
#  user_id         :bigint
#  organization_id :bigint
#  role            :integer
#

require 'rails_helper'

RSpec.describe OrganizationUser, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:organization) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:user_id).scoped_to([:organization_id]) }
    it { should define_enum_for(:role) }
  end
end
