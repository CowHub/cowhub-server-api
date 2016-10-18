class Tag < ActiveRecord::Base
  has_one :cattle, dependent: :destroy

  after_create :generate_cattle

  def generate_tag
    "#{country_code}#{format('%06d', herdmark)}#{check_digit}#{format('%05d', individual_number)}"
  end

  def self.parse_tag(tag)
    {
      country_code: tag[0..1],
      herdmark: tag[2..7],
      check_digit: tag[8],
      individual_number: tag[9..14]
    }
  end

  private

  def generate_cattle
    Cattle.create!(tag_id: id)
  end
end
