class Cattle < ActiveRecord::Base
  belongs_to :tag

  def to_json
    {
      tag: tag.generate_tag,
      name: name,
      breed: breed,
      gender: gender,
      dob: dob
    }
  end
end
