FactoryBot.define do
  factory :user do
    email "user@example.com"
    password "password"
    password_confirmation "password"
    confirmed_at Date.today
  end
end
