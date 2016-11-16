require 'rails_helper'

RSpec.describe VerificationImage, type: :model do
  it 'is valid with valid attributes' do
    FactoryGirl.create(:verification_image)
  end

  it 'is valid without an associated cattle' do
    image = FactoryGirl.build(:verification_image, cattle_id: nil)
    expect(image).to be_valid
  end
end
