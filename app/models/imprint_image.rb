class ImprintImage < ApplicationRecord
  belongs_to :cattle
  after_create :push_image

  validates :image_uri, presence: true
  attr_accessor :image

  def push_image
    self.image_uri = "cattle/#{cattle.user.id}/#{cattle.id}/#{id}-profile-original"
    $s3.put_object(
      acl: 'private',
      body: image,
      bucket: 'cowhub-production-images',
      key: image_uri
    )
    save!
  end

  def fetch_image
    {
      id: id,
      data: $s3.get_object(
        bucket: 'cowhub-production-images',
        key: image_uri
      ).body.read
    }
  end
end
