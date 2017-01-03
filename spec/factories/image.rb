require 'faker'

FactoryGirl.define do
  factory :image do
    cattle_id { FactoryGirl.create(:cattle).id }
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
end
