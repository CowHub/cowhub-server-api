require 'rails_helper'

RSpec.describe ImageController, type: :controller do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @cattle = FactoryGirl.create(:cattle, user_id: @user.id)
    FactoryGirl.create_list(:image, 20, cattle_id: @cattle.id)
    @auth_token = @user.generate_token
  end

  before(:each) do
    @request.headers['Authorization'] = "Bearer #{@auth_token}"
  end

  describe 'GET #index' do
    it 'get images for cattle with images' do
      get :index, params: { id: @cattle.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #upload' do
    it 'returns http success' do
      post :upload, params: { id: @cattle.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #verify' do
    it 'returns http success' do
      post :verify
      expect(response).to have_http_status(:success)
    end
  end
end
