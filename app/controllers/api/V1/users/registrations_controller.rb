# frozen_string_literal: true
module Api
  module V1
    class Users::RegistrationsController < Devise::RegistrationsController
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: {
            status: { code: 200, message: 'Signed up successfully.'},
            data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
          }
        else
          render json: {
            status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
