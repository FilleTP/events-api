# frozen_string_literal: true

module Events
  class CreateEventUseCase
    private attr_reader :params

    Response = Struct.new(:success?, :event, :errors, keyword_init: true)

    def initialize(params:, user:)
      @params = params
      @user = user
    end

    def call
      service_response = Events::CreateEventService.new(params: params, user: user).call

      return service_response unless service_response.success?

      event_json = Events::EventPresenter.new(event: service_response.event, user: user).call
      Response.new(success?: true, event: event_json)

    rescue => error
      log_exception(error)
      Response.new(success?: false, error: ["An unexpected error ocurred while presenting the event."])
    end

    private

    def log_exception(error)
      Rails.logger.error(
        message: "#{self.class} - Unexpected error",
        error_message: error.message,
        error_class: error.class,
        backtrace: error.backtrace&.first(3),
      )
    end
  end
end
