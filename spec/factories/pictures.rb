FactoryGirl.define do
  factory :picture do
    association :user, strategy: :create
    file do
      Rack::Test::UploadedFile.new(
        File.join(Rails.root, 'spec', 'support', 'test.jpg')
      )
    end

    trait :with_report do
      association :report, strategy: :create
    end
  end
end

