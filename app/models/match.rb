class Match < ApplicationRecord
  belongs_to :user
  belongs_to :imprint_image, required: false
  has_one :cattle, through: :imprint_image, required: false
  enum status: %w(pending found not_found)

  validates :image_uri, presence: true
end
