class Cattle < ActiveRecord::Base
  belongs_to :user

  validates :individual_number, uniqueness: { scope: [:country_code, :herdmark, :check_digit] }

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
