FactoryGirl.define do
  factory :cattle do
    user_id { FactoryGirl.create(:user).id }
    country_code 'UK'
    herdmark '230011'
    check_digit 7
    individual_number 2
    name 'Daisy'
    breed 'Wagyu'
    gender 'female'
    dob Date.today
  end
end
