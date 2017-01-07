class ImprintImage < ApplicationRecord
  belongs_to :cattle

  validates :cattle, presence: true
  validates :image_uri, presence: true
end
