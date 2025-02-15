module Events
  class EventPresenter
    private attr_reader :event, :user

    delegate :id, :name, :start_date, :end_date, :description, :capacity, :address, to: :event

    def initialize(event:, user:)
      @event = event
      @user = user
    end

    def call
      {
        id: id,
        name: name,
        start_date: start_date,
        end_date: end_date,
        description: description,
        capacity: capacity,
        address: address,
        creator: user&.name || "Unknown",
      }
    end
  end
end
