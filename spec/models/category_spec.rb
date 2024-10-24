require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'db columns' do
    it { should have_db_column(:name).of_type(:string) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'assoications' do
    it { should have_many(:events).dependent(:destroy) }
  end
end
