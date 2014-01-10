FactoryGirl.define do
  factory :user_love_report do
    association :user, strategy: :create
    association :report, strategy: :create
  end
end
