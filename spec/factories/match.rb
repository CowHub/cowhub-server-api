require 'faker'

FactoryGirl.define do
  factory :match do
    user_id { FactoryGirl.create(:user).id }
    image_uri do
      image_uri = "cattle/#{SecureRandom.base64}/#{SecureRandom.base64}/image-original"
      $s3.put_object(
        acl: 'private',
        body: SecureRandom.base64,
        bucket: 'cowhub-production-images',
        key: image_uri
      )
      image_uri
    end
  end

  factory :match_found, parent: :match do
    count 2
    results 2
    value { Faker::Number.number(5) }
  end
end
