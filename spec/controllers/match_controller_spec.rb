require 'rails_helper'

RSpec.describe MatchController, type: :controller do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @cattle = FactoryGirl.create(:cattle, user_id: @user.id)
    FactoryGirl.create_list(:profile_image, 20, cattle_id: @cattle.id)
    @auth_token = @user.generate_token
  end

  before(:each) do
    @request.headers['Authorization'] = "Bearer #{@auth_token}"
  end

  describe 'POST #new' do
    it 'no image returns bad request error' do
      post :new
      expect(response).to have_http_status(:bad_request)
    end

    it 'image returns match id' do
      post :new, params: { data: SecureRandom.base64 }
      body = JSON.parse response.body

      expect(response).to have_http_status(:success)
      expect(body['match']).to_not be(nil)
    end
  end

  describe 'GET #show' do
    it 'invalid id returns not found error' do
      get :show, params: { id: Faker::Number.number(10) }
      expect(response).to have_http_status(:not_found)
    end

    it 'is still unprocessed returns ok' do
      match = FactoryGirl.create(:match, user_id: @user.id)
      get :show, params: { id: match.id }
      body = JSON.parse response.body

      expect(response).to have_http_status(:ok)
      expect(body['pending']).to be(true)
    end

    it 'did not match any cattle returns found false' do
      match = FactoryGirl.create(:match, user_id: @user.id, status: 'not_found')
      get :show, params: { id: match.id }
      body = JSON.parse response.body

      expect(response).to have_http_status(:ok)
      expect(body['found']).to be(false)
    end

    it 'matched unregistered returns lost true' do
      match = FactoryGirl.create(:match, user_id: @user.id, status: 'found')
      get :show, params: { id: match.id }
      body = JSON.parse response.body

      expect(response).to have_http_status(:ok)
      expect(body['lost']).to be(true)
    end

    it 'matched cattle returns cattle' do
      match = FactoryGirl.create(:match, user_id: @user.id, cattle_id: @cattle.id, status: 'found')
      get :show, params: { id: match.id }
      body = JSON.parse response.body

      expect(response).to have_http_status(:success)
      expect(body['cattle']).to_not be(nil)
    end
  end
end
