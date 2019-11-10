# frozen_string_literal: true

require 'test_helper'

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:one)
  end

  test 'should get index' do
    get organizations_url, as: :json
    assert_response :success
  end

  test 'should create organization' do
    assert_difference('Organization.count') do
      post organizations_url, params: { organization: {} }, as: :json
    end

    assert_response 201
  end

  test 'should show organization' do
    get organization_url(@organization), as: :json
    assert_response :success
  end

  test 'should update organization' do
    patch organization_url(@organization), params: { organization: {} }, as: :json
    assert_response 200
  end
end
