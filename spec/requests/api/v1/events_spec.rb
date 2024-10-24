require 'rails_helper'

RSpec.describe 'Events', type: :request do
  let!(:user) { create(:user, email: 'event_creator@example.com', password: 'password123', password_confirmation: 'password123') }
  let!(:other_user) { create(:user, email: 'other_user@example.com', password: 'password1234', password_confirmation: 'password1234') }

  let!(:sport_category) { create(:category, :sport) }
  let!(:music_category) { create(:category, :music) }

  let!(:event) { create(:event, category: sport_category, user: user) }

  let(:valid_login_params) do
    {
      user: {
        email: 'event_creator@example.com',
        password: 'password123'
      }
    }
  end

  let(:valid_login_params_other_user) do
    {
      user: {
        email: 'other_user@example.com',
        password: 'password1234'
      }
    }
  end

  let(:valid_params) do
    {
      event: {
        name: 'Default Event',
        description: 'Default Event Description Written Here',
        capacity: '50',
        address: 'Passeig de Sant Joan, 55, 08009 Barcelona, Spain',
        start_date: DateTime.now.tomorrow.change({ hour: 9, min: 30 }),
        end_date: DateTime.now.tomorrow.change({ hour: 13, min: 30 }),
        category_id: music_category.id
      }
    }
  end

  let(:invalid_params) do
    {
      event: {
        name: '',
        description: '',
        capacity: '',
        address: '',
        start_date: '',
        end_date: '',
        category_id: ''
      }
    }
  end

  def login(user_params)
    post '/api/v1/login', params: user_params
    response.headers['Authorization']
  end

  describe 'GET /api/v1/events' do
    it 'returns a success message and all events' do
      get '/api/v1/events'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['status']['message']).to eq('Events fetched successfully.')
      expect(JSON.parse(response.body)['data']['events'].count).to eq(1)
    end
  end

  describe 'GET /api/v1/events/:id' do
    it 'returns a success message and correct event' do
      get "/api/v1/events/#{event.id}"

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['status']['message']).to eq('Event fetched successfully.')
      expect(JSON.parse(response.body)['data']['event']['id'].to_i).to eq(event.id)
    end
  end

  describe 'POST /api/v1/events' do
    context 'with valid params and authorized user' do
      it 'creates an event and returns a success message' do
        jwt_token = login(valid_login_params)

        post '/api/v1/events', headers: { 'Authorization': jwt_token }, params: valid_params

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['status']['message']).to eq('Event successfully created.')
        expect(JSON.parse(response.body)['data']['event']['name']).to eq('Default Event')
        expect(JSON.parse(response.body)['data']['event']['user_id']).to eq(user.id)
        expect(JSON.parse(response.body)['data']['event']['category_id']).to eq(music_category.id)
      end
    end

    context 'with invalid params and authorized user' do
      it 'does not create an event and returns an error message' do
        jwt_token = login(valid_login_params)

        post '/api/v1/events', headers: { 'Authorization': jwt_token }, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']['message']).to eq("Event couldn't be created.")
      end
    end
  end

  describe 'PATCH /api/v1/events/:id' do
    context 'with valid params and authorized user' do
      it 'updates the event and returns a sucess message' do
        jwt_token = login(valid_login_params)

        patch "/api/v1/events/#{event.id}", headers: { 'Authorization': jwt_token }, params: valid_params

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['status']['message']).to eq('Event updated successfully.')
        expect(JSON.parse(response.body)['data']['event']['category_id']).to eq(music_category.id)
      end
    end

    context 'with invalid params and authorized user' do
      it 'does not update the event and returns an error message' do
        jwt_token = login(valid_login_params)

        patch "/api/v1/events/#{event.id}", headers: { 'Authorization': jwt_token }, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']['message']).to eq("Event couldn't be updated.")
      end
    end

    context 'with valid params and wrong authorized user' do
      it 'does not update the event and returns an error message' do
        jwt_token = login(valid_login_params_other_user)

        patch "/api/v1/events/#{event.id}", headers: { 'Authorization': jwt_token }, params: valid_params

        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['status']['message']).to eq('You are not authorized to perform this action.')
      end
    end
  end

  describe 'DELETE /api/v1/events/:id' do
    context 'authorized user' do
      it 'deletes the event and returns a success message' do
        jwt_token = login(valid_login_params)

        delete "/api/v1/events/#{event.id}", headers: { 'Authorization': jwt_token }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['status']['message']).to eq("Event deleted successfully.")
        expect { event.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'wrong authorized user' do
      it 'does not delete the event and returns an error message' do
        jwt_token = login(valid_login_params_other_user)

        patch "/api/v1/events/#{event.id}", headers: { 'Authorization': jwt_token }

        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['status']['message']).to eq('You are not authorized to perform this action.')
      end
    end
  end
end
