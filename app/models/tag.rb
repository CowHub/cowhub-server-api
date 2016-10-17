class Tag < ActiveRecord::Base
  has_one :cattle, dependent: :destroy

  def self.new_from_params(params)
    tag = Tag.new(
      country_code: params[:country_code],
      herdmark: params[:herdmark],
      check_digit: params[:check_digit],
      individual_number: params[:individual_number]
    )
    tag.save!
    Cattle.create(tag_id: tag.id)
  end

  def self.find_from_params(params)
    Tag.find_by(
      country_code: params[:country_code],
      herdmark: params[:herdmark],
      check_digit: params[:check_digit],
      individual_number: params[:individual_number]
    )
  end

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
end
