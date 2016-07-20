FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    password Faker::Internet.password
    name Faker::Name.first_name
    surname Faker::Name.last_name
  end
end
