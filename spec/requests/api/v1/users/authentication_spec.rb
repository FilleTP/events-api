require 'rails_helper'

RSpec.describe 'JWT Authentication', type: :request do
  let!(:user) { create(:user, password: 'password123', password_confirmation: 'password123') }
  let!(:event) { create(:event, user: user) }

  let!(:valid_login_params) do
    {
      user:
      {
        email: user.email,
        password: 'password123'
      }
    }
  end

  describe 'POST /api/v1/protected_route' do
    context 'malformed jwt token' do
      it 'returns json error response for events protected route delete with Bearer + random set of numbers' do
        delete "/api/v1/events/#{event.id}", headers: { 'Authorization': 'Bearer 123123' }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['status']['message']).to include('JWT token is invalid or expired')
        expect(JSON.parse(response.body)['data']['error_code']).to eq(100011)
      end

      it 'returns json error response for events protected route delete without Bearer' do
        delete "/api/v1/events/#{event.id}", headers: { 'Authorization': '123123' }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['status']['message']).to include('JWT token is invalid or expired')
        expect(JSON.parse(response.body)['data']['error_code']).to eq(100011)
      end

      it 'returns json error response for sessions protected route delete with Bearer + random set of numbers' do
        delete '/api/v1/logout', headers: { 'Authorization': 'Bearer 123123' }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['status']['message']).to include('JWT token is invalid or expired')
        expect(JSON.parse(response.body)['data']['error_code']).to eq(100011)
      end

      it 'returns json error response for sessions protected route delete without Bearer' do
        delete '/api/v1/logout', headers: { 'Authorization': '123123' }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['status']['message']).to include('JWT token is invalid or expired')
        expect(JSON.parse(response.body)['data']['error_code']).to eq(100011)
      end
    end

    context 'invalid jwt token' do
      it 'returns json error response for events protected route delete' do
        post '/api/v1/login', params: valid_login_params
        invalid_jwt_token = response.headers['Authorization'].gsub(/.{4}$/, 'abcd')

        delete "/api/v1/events/#{event.id}", headers: { 'Authorization': invalid_jwt_token }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['status']['message']).to include('JWT token is invalid or expired')
        expect(JSON.parse(response.body)['data']['error_code']).to eq(100011)
      end

      it 'returns json error response for sessions protected route delete' do
        post '/api/v1/login', params: valid_login_params
        invalid_jwt_token = response.headers['Authorization'].gsub(/.{4}$/, 'abcd')

        delete "/api/v1/logout", headers: { 'Authorization': invalid_jwt_token }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['status']['message']).to include('JWT token is invalid or expired')
        expect(JSON.parse(response.body)['data']['error_code']).to eq(100011)
      end
    end
  end
end
