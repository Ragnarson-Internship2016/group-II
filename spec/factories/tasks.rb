FactoryGirl.define do
  factory :task do
    title Faker::Lorem.sentence(2, true, 0)
    description Faker::Lorem.sentence
    due_date Faker::Time.forward(10)
  end
end
