require 'faker'

FactoryGirl.define do
  factory :match do
    user_id { FactoryGirl.create(:user).id }
    image_uri { SecureRandom.base64 }
    status { 'pending' }
  end
end
