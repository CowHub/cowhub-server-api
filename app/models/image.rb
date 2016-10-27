class Image < ActiveRecord::Base
  belongs_to :cattle

  validates :image_uri, uniqueness: true
end
