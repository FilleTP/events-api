# frozen_string_literal: true
module Api
  module V1
    class Users::RegistrationsController < Devise::RegistrationsController
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        if resource.persisted?
          json_response 200, 'Signed up successfully.', user: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
        else
          json_response 422, "User couldn't be created successfully.", errors: resource.errors.full_messages.to_sentence
        end
      end
    end
  end
end
