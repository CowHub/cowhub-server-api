class VerificationImage < ApplicationRecord
  belongs_to :cattle
  validates :image_uri, presence: true
end