require 'rails_helper'

RSpec.describe Event, type: :model do
  shared_examples 'db columns' do |columns|
    columns.each do |column_name, type|
      it { should have_db_column(column_name).of_type(type)}
    end
  end

  shared_examples 'presence validations' do |columns|
    columns.each do |column|
      it { should validate_presence_of(column)}
    end
  end

  describe 'db columns' do
    include_examples 'db columns', {
      name: :string,
      description: :text,
      start_date: :datetime,
      end_date: :datetime,
      capacity: :integer,
      address: :string
    }
  end

  describe 'validations' do
    include_examples 'presence validations', [
      :name,
      :description,
      :start_date,
      :end_date,
      :capacity,
      :address
    ]
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
  end
end
