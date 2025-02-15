module Api
  module V1
    class EventsController < ApplicationController
      respond_to :json
      before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
      before_action :set_event, only: [:show, :edit, :update, :destroy]
      before_action :authorize_event_owner, only: [:edit, :update, :destroy]

      def index
        @events = Event.all
        json_response 200, 'Events fetched successfully.', events: @events
      end

      def show
        json_response 200, 'Event fetched successfully.', event: @event
      end

      def create
        response = Events::CreateEventUseCase.new(
          params: event_params,
          user: current_user,
        ).call
        
        if response.success?
          render json: { event: response.event }, status: :created
        else
          render json: { errors: response.errors }, status: :unproccessable_entity
        end
      end

      def update
        if @event.update(event_params)
          json_response 200, 'Event updated successfully.', event: @event
        else
          json_response 422, "Event couldn't be updated.", errors: @event.errors.full_messages
        end
      end

      def destroy
        if @event.destroy
          json_response 200, 'Event deleted successfully.'
        else
          json_response 422, "Event couldn't be deleted.", errors: @event.errors.full_messages
        end
      end

      private

      def set_event
        @event = Event.find(params[:id])
      end

      def event_params
        params.require(:event).permit(:name, :start_date, :end_date, :description, :capacity, :address, :category_id)
      end

      def authorize_event_owner
        authorize_owner(@event)
      end
    end
  end
end
