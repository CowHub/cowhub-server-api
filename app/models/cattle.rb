class Cattle < ActiveRecord::Base
  belongs_to :user
  has_many :image

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
