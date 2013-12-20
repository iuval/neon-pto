# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :report do
    user nil
    body "MyText"
    title "MyString"
    date "2013-12-20"
  end
end
