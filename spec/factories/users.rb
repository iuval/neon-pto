FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@neonroots.com"
  end

  factory :user do
    email
    password { 'changeme' }
  end
end
