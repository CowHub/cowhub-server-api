class Match < ApplicationRecord
  belongs_to :user
  belongs_to :cattle, optional: true
  enum status: %w(pending found not_found)

  validates :image_uri, presence: true
end
