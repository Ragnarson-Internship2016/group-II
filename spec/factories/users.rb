FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@gmail.cpm" }
    password Faker::Internet.password
    name Faker::Name.first_name
    surname Faker::Name.last_name
  end
end
