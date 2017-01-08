require 'rails_helper'

RSpec.describe ProfileImage, type: :model do
  it 'is valid with valid attributes' do
    FactoryGirl.create(:profile_image)
  end

  it 'is not valid without an associated cattle' do
    profile_image = FactoryGirl.build(:profile_image, cattle_id: nil)
    expect(profile_image).to_not be_valid
  end

  it 'is not valid without image_uri' do
    profile_image = FactoryGirl.build(:profile_image, image_uri: nil)
    expect(profile_image).to_not be_valid
  end
end
