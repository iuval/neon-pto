FactoryGirl.define do
  factory :report do
    association :user, strategy: :create
    body  { 'Report body' }
    title { 'Report title' }
    date  { DateTime.now }
  end
end
