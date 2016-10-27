require 'rails_helper'

RSpec.describe Cattle, type: :model do
  it 'is valid with valid attributes' do
    expect(FactoryGirl.create(:cattle)).to be_valid
  end

  it 'is not valid without a country_code' do
    cattle = FactoryGirl.build(:cattle)
    cattle.country_code = nil
    expect(cattle).to_not be_valid
  end

  it 'is not valid without a herdmark'
  it 'is not valid without a check_digit'
  it 'is not valid without an individual_number'
  it 'is not valid with an invalid country_code'
  it 'is not valid with an invalid herdmark'
  it 'is not valid with an invalid check_digit'
  it 'is not valid with an invalid individual_number'
end
