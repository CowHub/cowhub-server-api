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
      body = JSON.parse response.body

      expect(response).to have_http_status(:success)
      expect(body['images'].length).to be(20)
    end

    it 'get images for cattle with no images' do
      cattle = FactoryGirl.create(:cattle, user_id: @user.id)
      get :index, params: { id: cattle.id }
      body = JSON.parse response.body

      expect(response).to have_http_status(:success)
      expect(body['images'].length).to be(0)
    end
  end

  describe 'POST #upload' do
    it 'uploads with valid image data' do
      post :upload, params: { id: @cattle.id, data: SecureRandom.base64 }
      expect(response).to have_http_status(:success)
    end

    it 'fails with no image data' do
      post :upload, params: { id: @cattle.id, data: nil }
      expect(response).to have_http_status(:bad_request)
    end

    it 'fails with invalid cattle id' do
      post :upload, params: { id: @cattle.id + 1, data: SecureRandom.base64 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #verify' do
    it 'no image returns nothing' do
      post :verify, params: { data: nil }
      body = JSON.parse response.body

      expect(response).to have_http_status(:success)
      expect(body['cattle'].length).to be(0)
    end

    it 'image with multiple cattle returns them' do
      cattle = FactoryGirl.create_list(:cattle, 25)
      image_data = SecureRandom.base64
      cattle.each do |c|
        FactoryGirl.create(:image, cattle_id: c.id, image_uri: image_data)
      end
      post :verify, params: { data: image_data }
      body = JSON.parse response.body

      expect(response).to have_http_status(:success)
      expect(body['cattle'].length).to be(25)
    end
  end
end