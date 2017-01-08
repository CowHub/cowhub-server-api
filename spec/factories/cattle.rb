require 'faker'

FactoryGirl.define do
  factory :cattle do
    user_id { FactoryGirl.create(:user).id }
    country_code 'UK'
    herdmark { format('%06d', Faker::Number.between(1, 999_999)) }
    check_digit { Faker::Number.between(1, 9) }
    individual_number { Faker::Number.between(1, 99_999) }
  end

  factory :cattle_extended, parent: :cattle do
    name { Faker::Name.name }
    breed 'BRO'
    gender 'female'
    dob Date.today
    genetic_dam 'UK190996300208'
    surrogate_dam 'UK190996300208'
    sir_dam 'UK190996400143'
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
