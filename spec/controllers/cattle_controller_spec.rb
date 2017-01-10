require 'rails_helper'

RSpec.describe CattleController, type: :controller do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @auth_token = @user.generate_token
  end

  before(:each) do
    @request.headers['Authorization'] = "Bearer #{@auth_token}"
  end

  describe 'GET #show' do
    it 'get unregistered cattle' do
      get :show, params: { id: Faker::Number.number(1_000) }
      expect(response).to have_http_status(:not_found)
    end

    it 'get registered cattle' do
      cattle = FactoryGirl.create(:cattle_extended, user_id: @user.id)
      get :show, params: { id: cattle.id }
      expect(response).to have_http_status(:ok)
    end

    it 'get deleted cattle returns http error' do
      cattle = FactoryGirl.create(:cattle_extended, user_id: @user.id)
      id = cattle.id
      cattle.destroy
      get :show, params: { id: id }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #new' do
    it 'post registration of unregistered tags' do
      params = {
        cattle: FactoryGirl.attributes_for(:cattle),
        imprint_image: SecureRandom.base64
      }
      post :new, params: params
      expect(response).to have_http_status(:created)
    end

    it 'post registration of unregistered tags with extra detail' do
      params = {
        cattle: FactoryGirl.attributes_for(:cattle_extended),
        imprint_image: SecureRandom.base64,
        profile_image: SecureRandom.base64
      }
      post :new, params: params
      expect(response).to have_http_status(:created)
    end

    it 'post registration without muzzle image' do
      post :new, params: { cattle: FactoryGirl.attributes_for(:cattle) }
      expect(response).to have_http_status(:bad_request)
    end

    it 'post registration of already registered tags returns http error' do
      cattle = { cattle: FactoryGirl.attributes_for(:cattle) }
      post :new, params: cattle
      post :new, params: cattle
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'POST #search' do
    before(:all) do
      FactoryGirl.create(:cattle, user_id: @user.id, herdmark: '230011', check_digit: '7')
      FactoryGirl.create(:cattle, user_id: @user.id, herdmark: '230011', check_digit: '5')
      FactoryGirl.create(:cattle, user_id: @user.id, check_digit: '7')
      FactoryGirl.create(:cattle, user_id: @user.id, country_code: 'FR', herdmark: '230011', check_digit: '7')
    end

    it 'using country_code' do
      post :search, params: { country_code: 'UK' }
      cattle = JSON.parse(response.body)['cattle']
      expect(cattle.length).to eq(3)
    end

    it 'using check_digit' do
      post :search, params: { check_digit: 7 }
      cattle = JSON.parse(response.body)['cattle']
      expect(cattle.length).to eq(3)
    end

    it 'using country_code and herdmark' do
      post :search, params: { country_code: 'UK', herdmark: '230011' }
      cattle = JSON.parse(response.body)['cattle']
      expect(cattle.length).to eq(2)
    end
  end

  describe 'PUT #update' do
    it 'put update to unregistered cattle returns http error' do
      put :update, params: FactoryGirl.attributes_for(:cattle, user_id: @user.id, id: Faker::Number.number(1_000))
      expect(response).to have_http_status(:not_found)
    end

    it 'put update to registered cattle updates info returns http success' do
      cattle = FactoryGirl.create(:cattle, user_id: @user.id)
      put :update, params: {
        id: cattle.id, name: 'Daisy', gender: 'female',
        breed: 'KIWI', dob: Date.today
      }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE #destroy' do
    it 'delete unregistered cattle returns http error' do
      delete :destroy, params: { id: '42' }
      expect(response).to have_http_status(:not_found)
    end

    it 'delete registered cattle returns http success' do
      cattle = FactoryGirl.create(:cattle, user_id: @user.id)
      delete :destroy, params: { id: cattle.id }
      expect(response).to have_http_status(:ok)
    end
  end

  private

  def auth_token(email, password)
    post :new_session, controller: :authentication_controller, params: { email: email, password: password }
    response_body = JSON.parse(response.body)
    response_body['auth_token']
  end
end
