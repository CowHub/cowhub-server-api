class Match < ApplicationRecord
  belongs_to :user
  belongs_to :imprint_image, required: false
  has_one :cattle, through: :imprint_image, required: false

  validates :image_uri, presence: true
  validates :stored, default: false
end
