require 'rails_helper'

RSpec.describe 'User Registration', type: :request do
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

  describe 'POST /api/v1/signup' do
    context 'with valid params' do
      it 'creates a user and returns success message' do
        post '/api/v1/signup', params: valid_params, as: :json
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['status']['message']).to eq('Signed up successfully.')
      end
    end

    context 'with invalid params' do
      it 'does not create a user and returns error message' do
        post '/api/v1/signup', params: invalid_params, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']['message']).to include("User couldn't be created successfully.")
      end
    end
  end
end
