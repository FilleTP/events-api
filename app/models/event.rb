class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category
  validates :name, :start_date, :end_date, :address, :description, :capacity, presence: true
end
