module Api
  module V1
    class CategoriesController < ApplicationController
      def index
        @categories = Category.all
        json_response 200, 'Fetched categories successfully', categories: @categories
      end
    end
  end
end
