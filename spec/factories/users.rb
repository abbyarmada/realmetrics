FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test_#{n}@test.org" }
    password '00000000'
  end
end
