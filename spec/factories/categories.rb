FactoryBot.define do
  factory :category do
    name { 'Category Default' }
    
    trait :sport do
      name { 'Sport' }
    end

    trait :music do
      name { 'Music' }
    end

    trait :art do
      name { 'Art' }
    end

    trait :cooking do
      name { 'Cooking' }
    end

    trait :spiritual do
      name { 'Spiritual' }
    end
  end
end
