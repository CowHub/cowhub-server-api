require 'rails_helper'

RSpec.describe BiometricImprint, type: :model do
  it 'is valid with valid attributes' do
    FactoryGirl.create(:biometric_imprint)
  end

  it 'is not valid without an associated cattle' do
    biometric_imprint = FactoryGirl.build(:biometric_imprint, cattle_id: nil)
    expect(biometric_imprint).to_not be_valid
  end

  it 'is not valid without image_uri' do
    biometric_imprint = FactoryGirl.build(:biometric_imprint, image_uri: nil)
    expect(biometric_imprint).to_not be_valid
  end
end
