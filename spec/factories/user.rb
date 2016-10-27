require 'faker'

FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    password 'changeme'
    password_confirmation 'changeme'
  end
end
