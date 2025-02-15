module Events
  class CreateEventService
    private attr_reader :params, :user

    Response = Struct.new(:success?, :event, :errors, keyword_init: true)

    def initialize(params:, user:)
      @params = params
      @user = user
    end

    def call
      event = nil
      ActiveRecord::Base.transaction do
        event = Event.create!(params.merge(user: user))
      end

      Response.new(success?: true, event: event)

    rescue ActiveRecord::RecordInvalid => error
      log_error(error)
      Response.new(success?: false, errors: error.record.errors.full_messages)

    rescue => error
      log_exception(error)
      Response.new(success?: false, errors: ["An unexpected error ocurred while creating the event"])
    end

    private

    def log_error(error)
      Rails.logger.error(
        message: "#{self.class} - Failed to create event",
        error_message: error.message,
        error_class: error.class.name,
        event_params: params,
      )
    end

    def log_exception(error)
      Rails.logger.error(
        message: "#{self.class} - Unexpected error",
        error_message: error.messages,
        error_class: error.class.name,
        event_params: params,
        backtrace: error.backtrace&.first(3),
      )
    end
  end
end
