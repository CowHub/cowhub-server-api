require 'rails_helper'

RSpec.describe Image, type: :model do
  it 'is valid with valid attributes' do
    FactoryGirl.create(:image)
  end

  it 'is not valid without an associated cattle' do
    image = FactoryGirl.build(:image, cattle_id: nil)
    expect(image).to_not be_valid
  end

  it 'is not valid without image_uri' do
    image = FactoryGirl.build(:image, image_uri: nil)
    expect(image).to_not be_valid
  end
end
