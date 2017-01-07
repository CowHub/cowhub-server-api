class Cattle < ActiveRecord::Base
  belongs_to :user
  has_many :biometric_imprint, dependent: :destroy
  has_many :profile_picture, dependent: :destroy

  before_save :before_save

  validates :country_code, presence: true,
                           length: { is: 2 },
                           format: { with: /[A-Za-z]{2}/ }
  validates :herdmark, presence: true,
                       length: { is: 6 },
                       format: { with: /([A-Za-z]{2}[0-9]{4}|[0-9]{6})/ }
  validates :check_digit, numericality: { greater_than: 0, less_than: 10 }, presence: true
  validates :individual_number, numericality: { greater_than: 0, less_than: 100_000 },
                                uniqueness: { scope: [:country_code, :herdmark, :check_digit] },
                                presence: true

  def before_save
    self.country_code = country_code.upcase
    self.herdmark = herdmark.upcase
  end

  def generate_tag
    "#{country_code}#{herdmark}#{check_digit}#{format('%05d', individual_number)}"
  end

  def imprint(data)
    imprint = biometric_imprint.create(image_uri: 'temporary')
    image_uri = "cattle/#{user.id}/#{id}/#{imprint.id}-imprint-original"
    $s3.put_object(
      acl: 'private',
      body: data,
      bucket: 'cowhub-production-images',
      key: image_uri
    )
    imprint.image_uri = image_uri
    imprint.save
    imprint
  end

  def add_image(data)
    profile = profile_picture.create(image_uri: 'temporary')
    image_uri = "cattle/#{user.id}/#{id}/#{profile.id}-profile-original"
    $s3.put_object(
      acl: 'private',
      body: data,
      bucket: 'cowhub-production-images',
      key: image_uri
    )
    profile.image_uri = image_uri
    profile.save
    profile
  end

  def images
    images = []
    profile_picture.each do |i|
      images.append(
        id: i.id,
        data: $s3.get_object(
          bucket: 'cowhub-production-images',
          key: i.image_uri
        ).body.read
      )
    end
    images
  end

  def to_json
    {
      tag: generate_tag,
      name: name,
      breed: breed,
      gender: gender,
      dob: dob
    }
  end
end
