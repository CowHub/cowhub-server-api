require 'rails_helper'

RSpec.describe Cattle, type: :model do
  it 'is valid with valid attributes' do
    expect(FactoryGirl.create(:cattle)).to be_valid
  end

  it 'is valid with lowercase country_code' do
    cattle = FactoryGirl.build(:cattle)
    cattle.country_code = cattle.country_code.downcase
    expect(cattle).to be_valid
  end

  it 'is valid with lowercase herdmark' do
    cattle = FactoryGirl.build(:cattle)
    cattle.herdmark = cattle.herdmark.downcase
    expect(cattle).to be_valid
  end

  it 'invalid without a country_code' do
    cattle = FactoryGirl.build(:cattle)
    cattle.country_code = nil
    expect(cattle).to_not be_valid
  end

  it 'invalid without a herdmark' do
    cattle = FactoryGirl.build(:cattle)
    cattle.herdmark = nil
    expect(cattle).to_not be_valid
  end

  it 'invalid without a check_digit' do
    cattle = FactoryGirl.build(:cattle)
    cattle.check_digit = nil
    expect(cattle).to_not be_valid
  end

  it 'invalid without an individual_number' do
    cattle = FactoryGirl.build(:cattle)
    cattle.individual_number = nil
    expect(cattle).to_not be_valid
  end

  it 'invalid with an invalid country_code (longer)' do
    cattle = FactoryGirl.build(:cattle)
    cattle.country_code = 'BLA'
    expect(cattle).to_not be_valid
  end

  it 'invalid with an invalid country_code (shorter)' do
    cattle = FactoryGirl.build(:cattle)
    cattle.country_code = 'A'
    expect(cattle).to_not be_valid
  end

  it 'invalid with an invalid herdmark (longer)' do
    cattle = FactoryGirl.build(:cattle)
    cattle.herdmark = '1000000'
    expect(cattle).to_not be_valid
  end

  it 'invalid with an invalid herdmark (shorter)' do
    cattle = FactoryGirl.build(:cattle)
    cattle.herdmark = '10000'
    expect(cattle).to_not be_valid
  end

  it 'invalid with an invalid check_digit (greater)' do
    cattle = FactoryGirl.build(:cattle)
    cattle.check_digit = 10
    expect(cattle).to_not be_valid
  end

  it 'invalid with an invalid check_digit (zero)' do
    cattle = FactoryGirl.build(:cattle)
    cattle.check_digit = 0
    expect(cattle).to_not be_valid
  end

  it 'invalid with an invalid individual_number (negative)' do
    cattle = FactoryGirl.build(:cattle)
    cattle.individual_number = -10
    expect(cattle).to_not be_valid
  end

  it 'invalid with an invalid individual_number (more than 99,999)' do
    cattle = FactoryGirl.build(:cattle)
    cattle.individual_number = 100_000
    expect(cattle).to_not be_valid
  end
end
