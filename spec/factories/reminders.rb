FactoryBot.define do
  factory :reminder do
    user
    title "Title"
    description "Description"
    time_zone "UTC"
    jobid "jobid"

    trait :future_time do
      time 20.minutes.from_now
    end
  end
end
