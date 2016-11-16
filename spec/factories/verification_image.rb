require 'faker'

FactoryGirl.define do
  factory :verification_image do
    cattle_id { FactoryGirl.create(:cattle).id }
    image_uri { SecureRandom.base64 }
  end
end
