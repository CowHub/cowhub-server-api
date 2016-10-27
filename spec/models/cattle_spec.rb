require 'rails_helper'

RSpec.describe Cattle, type: :model do
  before(:all) do
    @valid_attributes = {
      country_code: 'UK', herdmark: '230011',
      check_digit: '7', individual_number: '00002',
      name: 'Daisy', breed: 'Wagyu', gender: 'female', dob: Date.today
    }
  end

  it 'is valid with valid attributes' do
    expect()
  end

  it 'is not valid without a country_code'
  it 'is not valid without a herdmark'
  it 'is not valid without a check_digit'
  it 'is not valid without an individual_number'
  it 'is not valid with an invalid country_code'
  it 'is not valid with an invalid herdmark'
  it 'is not valid with an invalid check_digit'
  it 'is not valid with an invalid individual_number'
end
