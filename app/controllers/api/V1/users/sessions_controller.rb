# frozen_string_literal: true
module Api
  module V1
    class Users::SessionsController < Devise::SessionsController
      respond_to :json

      private

      def respond_with(current_user, _opts = {})
        json_response 200, 'Logged in successfully.', user: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      end

      def respond_to_on_destroy
        if request.headers['Authorization'].present?
          begin
            token = request.headers['Authorization'].split(' ').last
            jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
            current_user = User.find_by(id: jwt_payload['sub'])

            if current_user
              json_response 200, 'Logged out successfully.'
            else
              json_response 401, "Couldn't find an active session."
            end

          rescue JWT::DecodeError
            json_response 401, 'JWT token is invalid or expired', error_code: 100011
          end
        else
          json_response 401, 'JWT token is invalid or expired', error_code: 100011
        end
      end
    end
  end
end
