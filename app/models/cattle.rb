class Cattle < ActiveRecord::Base
  validates :individual_number, uniqueness: { scope: [:country_code, :herdmark, :check_digit] }
  has_one :biometric_imprint

  def generate_tag
    "#{country_code}#{format('%06d', herdmark)}#{check_digit}#{format('%05d', individual_number)}"
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
