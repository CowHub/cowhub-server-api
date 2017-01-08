class Cattle < ActiveRecord::Base
  belongs_to :user
  has_many :imprint_image, dependent: :destroy
  has_many :profile_image, dependent: :destroy

  before_save :before_save

  enum gender: %w(male female)
  enum breed: %w(AA AB ALL AR AN AM AU AY BRO BAZ BEL BSH BD BG BWB BI BA BAL BLG BR BP BRB BF BW BS CH CHI CHL CW DR DS DEV DEX DZE EFB EP ER FKV FE GAS GA GAY GE GL GB GU HK HE HI HO HF HS IM JE KE KIWI LV LIM LR LH LU MA MAL MAR MRI MO MG NO NDS NR OE OD PA PI PIN RP RE RG RO ROT SA SH SHO SM SD SP ST SR SRP SRW SB SOB SG SU TB TT VN VA WA BU WB WW WG WS WP YK ZE)

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
  validates :genetic_dam, length: { is: 14 },
                          format: { with: /([A-Za-z]{4}[0-9]{10}|[A-Za-z]{2}[0-9]{12})/ },
                          allow_blank: true
  validates :surrogate_dam, length: { is: 14 },
                            format: { with: /([A-Za-z]{4}[0-9]{10}|[A-Za-z]{2}[0-9]{12})/ },
                            allow_blank: true
  validates :sir_dam, length: { is: 14 },
                      format: { with: /([A-Za-z]{4}[0-9]{10}|[A-Za-z]{2}[0-9]{12})/ },
                      allow_blank: true

  def before_save
    self.country_code = country_code.upcase
    self.herdmark = herdmark.upcase
  end

  def generate_tag
    "#{country_code}#{herdmark}#{check_digit}#{format('%05d', individual_number)}"
  end

  def profile_images
    images = []
    profile_image.each do |i|
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

  def as_json(options = {})
    hash = super(options)
    hash.delete 'latitude'
    hash.delete 'longitude'
    hash[:image_ids] = profile_image.ids
    hash[:location] = {
      lat: latitude,
      lng: longitude
    }
    hash
  end
end
