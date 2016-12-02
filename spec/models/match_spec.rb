require 'rails_helper'

RSpec.describe Match, type: :model do
  it 'is valid with valid attributes' do
    FactoryGirl.create(:match)
  end
end
