require 'rails_helper'

RSpec.describe ProfilePicture, type: :model do
  it 'is valid with valid attributes' do
    FactoryGirl.create(:profile_picture)
  end

  it 'is not valid without an associated cattle' do
    profile_picture = FactoryGirl.build(:profile_picture, cattle_id: nil)
    expect(profile_picture).to_not be_valid
  end

  it 'is not valid without image_uri' do
    profile_picture = FactoryGirl.build(:profile_picture, image_uri: nil)
    expect(profile_picture).to_not be_valid
  end
end
