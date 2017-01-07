require 'faker'

FactoryGirl.define do
  factory :cattle do
    user_id { FactoryGirl.create(:user).id }
    biometric_imprint 'cattle/42/biometric-imprint-original'
    country_code 'UK'
    herdmark { format('%06d', Faker::Number.between(1, 999_999)) }
    check_digit { Faker::Number.between(1, 9) }
    individual_number { Faker::Number.between(1, 99_999) }
  end

  factory :cattle_extended, parent: :cattle do
    name { Faker::Name.name }
    breed { Faker::Hacker.noun }
    gender 'female'
    dob Date.today
  end
end
