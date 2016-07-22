FactoryGirl.define do
  factory :project do
    title Faker::Lorem.sentence(2, true, 0)
    description Faker::Lorem.sentence
    date Faker::Time.forward(10)
    user

    factory :project_with_contributors do
      contributors { [create(:user)] }
    end

    factory :project_with_events do
      transient do
        events_count 3
      end

      after(:build) do |project, evaluator|
        create_list(:event, evaluator.events_count, project: project)
      end
    end

    factory :project_with_tasks do
      transient do
        tasks_count 3
      end

      after(:create) do |project, evaluator|
        create_list(:task, evaluator.tasks_count, project: project)
      end
    end
  end
end
