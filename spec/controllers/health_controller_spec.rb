require 'rails_helper'

RSpec.describe HealthController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns status online' do
      expected = {
        status: 'online'
      }.to_json

      get :index
      expect(response.body).to eq(expected)
    end
  end
end
