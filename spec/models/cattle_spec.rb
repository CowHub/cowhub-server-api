require 'rails_helper'

RSpec.describe Cattle, type: :model do
  it 'is valid with valid attributes'
  it 'is not valid without a country_code'
  it 'is not valid without a herdmark'
  it 'is not valid without a check_digit'
  it 'is not valid without an individual_number'
end
