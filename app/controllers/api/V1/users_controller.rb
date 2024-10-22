module Api
  module V1
    class UsersController < ApplicationController
      respond_to :json
      before_action :authenticate_user!

      def profile
        render json: current_user
      end
    end
  end
end
