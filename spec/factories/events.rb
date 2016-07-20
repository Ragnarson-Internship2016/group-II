FactoryGirl.define do
  factory :event do
    title Faker::Lorem.sentence(2, true, 0)
    description Faker::Lorem.sentence
    date Faker::Time.forward(10)
    association :author, factory: :user
    project
  end
end
