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
    it 'no image returns bad request error' do
      post :request_verification
      expect(response).to have_http_status(:bad_request)
    end

    it 'image returns verification image ID' do
      post :request_verification, params: { data: SecureRandom.base64 }
      body = JSON.parse response.body

      expect(response).to have_http_status(:success)
      expect(body['verificationID']).to_not be(nil)
    end
  end

  describe 'GET #verify' do
    it 'invalid id returns not found error' do
      get :check_verification, params: { id: Faker::Number.number(10) }
      expect(response).to have_http_status(:not_found)
    end

    it 'is still unprocessed returns ok' do
      verification = FactoryGirl.create(:verification_image)
      get :check_verification, params: { id: verification.id }
      expect(response).to have_http_status(:success)
    end

    it 'did not match any cattle returns not found error' do
      verification = FactoryGirl.create(:verification_image, cattle_id: -1)
      get :check_verification, params: { id: verification.id }
      expect(response).to have_http_status(:not_found)
    end

    it 'matched unregistered returns not found error' do
      verification = FactoryGirl.create(:verification_image, cattle_id: 0)
      get :check_verification, params: { id: verification.id }
      expect(response).to have_http_status(:not_found)
    end

    it 'matched cattle returns cattle' do
      verification = FactoryGirl.create(:verification_image, cattle_id: @cattle.id)
      get :check_verification, params: { id: verification.id }
      expect(response).to have_http_status(:success)
    end
  end
end
