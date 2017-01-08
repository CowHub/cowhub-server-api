class Match < ApplicationRecord
  belongs_to :user
  enum status: %w(pending found not_found)

  validates :image_uri, presence: true
end
