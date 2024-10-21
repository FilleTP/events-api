require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_db_column(:email).of_type(:string) }
  it { should have_db_column(:encrypted_password).of_type(:string) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email).case_insensitive }

  describe 'password encryption' do
    it 'should encrypt the password' do
      user = create(:user, password: "password123")
      expect(user.encrypted_password).not_to eq("password123")
    end
  end
end
