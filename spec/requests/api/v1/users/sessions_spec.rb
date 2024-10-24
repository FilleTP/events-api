require 'rails_helper'

RSpec.describe 'User Login', type: :request do
  let!(:user) { create(:user) }

  let(:valid_params) do
    {
      user: {
        email: 'test@example.com',
        password: 'password123',
      }
    }
  end

  let(:invalid_params) do
    {
      user: {
        email: '',
        password: '',
      }
    }
  end

  describe 'POST /api/v1/login' do
    context 'with valid params' do
      it 'returns a success message' do
        post '/api/v1/login', params: valid_params

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['status']['message']).to eq('Logged in successfully.')
        expect(JSON.parse(response.body)['data']['user']['email']).to eq('test@example.com')
        expect(response.headers['Authorization']).to match(/^Bearer /)
      end
    end

    context 'with invalid params' do
      it 'returns an error message' do
        post '/api/v1/login', params: invalid_params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/logout' do
    context 'with valid token' do
      it 'returns success message and deletes jwt token' do
        post '/api/v1/login', params: valid_params
        jwt_token = response.headers['Authorization']

        delete '/api/v1/logout', headers: { 'Authorization': jwt_token }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['status']['message']).to eq('Logged out successfully.')


        get '/api/v1/profile', headers: { 'Authorization': jwt_token }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with malformed token' do
      it 'returns error message' do
        delete '/api/v1/logout', headers: { 'Authorization': 'Bearer 123123'}

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['status']['message']).to eq('JWT token is invalid or expired.')
        expect(JSON.parse(response.body)['data']['error_code']).to eq(100011)
      end
    end
  end
end
