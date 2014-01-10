FactoryGirl.define do
  factory :report do
    association :user, strategy: :create
    body  { 'Report body' }
    title { 'Report title' }
    date  { DateTime.now }

    trait :published do
      published { true }
    end

    trait :unpublished do
      published { false }
    end
  end
end
