require 'rails_helper'

RSpec.describe MatchController, type: :controller do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @cattle = FactoryGirl.create(:cattle, user_id: @user.id)
    FactoryGirl.create_list(:image, 20, cattle_id: @cattle.id)
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
      expect(body['matchId']).to_not be(nil)
    end
  end

  describe 'GET #verify' do
    it 'invalid id returns not found error' do
      get :show, params: { id: Faker::Number.number(10) }
      expect(response).to have_http_status(:not_found)
    end

    it 'is still unprocessed returns ok' do
      match = FactoryGirl.create(:match)
      get :show, params: { id: match.id }
      expect(response).to have_http_status(:success)
    end

    it 'did not match any cattle returns not found error' do
      match = FactoryGirl.create(:match, status: 'not_found')
      get :show, params: { id: match.id }
      expect(response).to have_http_status(:not_found)
    end

    it 'matched unregistered returns not found error' do
      match = FactoryGirl.create(:match, status: 'found')
      get :show, params: { id: match.id }
      expect(response).to have_http_status(:not_found)
    end

    it 'matched cattle returns cattle' do
      match = FactoryGirl.create(:match, cattle_id: @cattle.id)
      get :show, params: { id: match.id }
      expect(response).to have_http_status(:success)
    end
  end
end