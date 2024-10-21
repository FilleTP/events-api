require 'rails_helper'

RSpec.describe 'User Login', type: :request do
  let!(:user) { create(:user) }

  let(:valid_params) do
    {
      user: {
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }
  end

  let(:invalid_params) do
    {
      user: {
        email: '',
        password: '',
        password_confirmation: ''
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
end
