FactoryGirl.define do
  factory :project do
    title Faker::Lorem.sentence(2, true, 0)
    description Faker::Lorem.sentence
    date Faker::Time.forward(10)
  end
end
