module Api
  module V1
    class UsersController < ApplicationController
      respond_to :json
      before_action :authenticate_user!

      def profile
        json_response 200, 'Fetched the user successfully', user: current_user
      end
    end
  end
end
