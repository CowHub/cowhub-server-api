class ImprintImage < ApplicationRecord
  belongs_to :cattle
  has_many :match, dependent: :destroy
  after_create :push_image
  before_destroy :delete_image_s3

  validates :image_uri, presence: true
  attr_accessor :image

  def push_image
    self.image_uri = "cattle/#{cattle.user.id}/#{cattle.id}/#{id}-imprint-original"
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

  def delete_image_s3
    begin
      $s3.delete_object(
        bucket: 'cowhub-production-images',
        key: image_uri
      )
    rescue Error
      puts "Couldn't delete image with ID #{id}"
    end
  end
end
