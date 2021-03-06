require 'faker'

FactoryGirl.define do
  factory :imprint_image do
    cattle { FactoryGirl.create(:cattle) }
    image_uri do
      image_uri = "cattle/#{cattle.user.id}/#{cattle.id}/#{Faker::Number.between(1, 999)}-imprint-original"
      $s3.put_object(
        acl: 'private',
        body: SecureRandom.base64,
        bucket: 'cowhub-production-images',
        key: image_uri
      )
      image_uri
    end
  end
end
