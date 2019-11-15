# frozen_string_literal: true

require_relative 'auth'

def request(headers = {})
  options = { headers: headers, params: body, as: :json }
  # options[:headers]['Content-Type'] = 'application/json'

  return get url, options if method == :get
  return post url, options if method == :post
  return put url, options if method == :put

  delete url, options
end

shared_examples_for 'an authenticated request' do
  context 'when the request is not authenticated' do
    it 'responds with unauthorized status' do
      request
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

shared_examples_for 'a forbidden request' do
  it 'responds with forbidden status' do
    request(authenticated_header(requester))
    expect(response).to have_http_status(:forbidden)
  end
end

shared_examples_for 'an unprocessable_entity request' do
  it 'responds with unprocessable_entity status' do
    request(authenticated_header(requester))
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

shared_examples_for 'an ok request' do
  it 'responds with an ok status' do
    expect(response).to have_http_status(:ok)
  end
end

shared_examples_for 'a created request' do
  it 'responds with created status' do
    expect(response).to have_http_status(:created)
  end
end

shared_examples_for 'a no_content request' do
  it 'responds with no_content status' do
    expect(response).to have_http_status(:no_content)
  end
end
