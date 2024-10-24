FactoryBot.define do
  factory :event do
    name { 'Default Event' }
    description { 'Default Event Description Written Here' }
    start_date { DateTime.now.tomorrow.change({ hour: 9, min: 30 }) }
    end_date { DateTime.now.tomorrow.change({ hour: 13, min: 30 }) }
    capacity { 50 }
    address { 'Passeig de Sant Joan, 55, 08009 Barcelona, Spain' }
    association :user
    association :category

    trait :sport_event do
      name { 'Barcelona 10K Run' }
      description { 'Join us for a thrilling 10K run through the heart of Barcelona. Perfect for both beginners and seasoned runners.' }
      start_date { DateTime.now.tomorrow.change({ hour: 9, min: 30 }) }
      end_date { DateTime.now.tomorrow.change({ hour: 13, min: 30 }) }
      capacity { 50 }
      address { 'Passeig de Sant Joan, 55, 08009 Barcelona, Spain' }
      association :user
      association :category, factory: [:category, :sport]
    end
  end
end
