require 'rails_helper'

RSpec.describe ImprintImage, type: :model do
  it 'is valid with valid attributes' do
    FactoryGirl.create(:imprint_image)
  end

  it 'is not valid without an associated cattle' do
    imprint_image = FactoryGirl.build(:imprint_image, cattle_id: nil)
    expect(imprint_image).to_not be_valid
  end

  it 'is not valid without image_uri' do
    imprint_image = FactoryGirl.build(:imprint_image, image_uri: nil)
    expect(imprint_image).to_not be_valid
  end
end
