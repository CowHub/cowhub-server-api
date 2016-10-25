class BiometricImprint < ActiveRecord::Base
  belongs_to :cattle
  validates :cattle_id, uniqueness: true
  validates :imprint, uniqueness: true
end
