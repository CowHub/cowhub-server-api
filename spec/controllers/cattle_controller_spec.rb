require 'rails_helper'

RSpec.describe CattleController, type: :controller do
  describe 'GET #index' do
    it 'get unregistered cattle returns http error' do
      get :index, params: { tag: 'UK230011700002' }
      expect(response).to have_http_status(404)
    end
  end

  describe 'POST #new' do
    it 'register cattle (through tag) then retieve' do
      post :new, params: { country_code: 'UK', herdmark: '230011',
                           check_digit: '7', individual_number: '00002' }
      expect(response).to have_http_status(201)

      get :index, params: { tag: 'UK230011700002' }
      expect(response).to have_http_status(200)
    end

    it 'register twice same cattle returns http error' do
      post :new, params: { country_code: 'UK', herdmark: '230011',
                           check_digit: '7', individual_number: '00002' }
      expect(response).to have_http_status(201)

      post :new, params: { country_code: 'UK', herdmark: '230011',
                           check_digit: '7', individual_number: '00002' }
      expect(response).to have_http_status(400)
    end
  end

  describe 'POST #update_cattle_info' do
    it 'register cattle with information' do
      post :update_cattle_info, params: {
        tag: 'UK230011700002', name: 'Daisy', breed: 'Wagyu',
        gender: 'female', dob: Date.today
      }
      expect(response).to have_http_status(200)

      get :index, params: { tag: 'UK230011700002' }
      expect(response.body).to eq({ cattle: { tag: 'UK230011700002', name:
        'Daisy', breed: 'Wagyu', gender: 'female', dob: Date.today } }.to_json)
    end

    it 'update registered cattle information' do
      post :new, params: { country_code: 'UK', herdmark: '230011',
                           check_digit: '7', individual_number: '00002' }
      expect(response).to have_http_status(201)

      post :update_cattle_info, params: {
        tag: 'UK230011700002', name: 'Daisy', breed: 'Wagyu',
        gender: 'female', dob: Date.today
      }
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE #destroy' do
    it 'delete unregistered cattle returns http error' do
      delete :destroy, params: { tag: 'UK230011700002' }
      expect(response).to have_http_status(404)
    end

    it 'delete registered cattle returns http success' do
      post :new, params: { country_code: 'UK', herdmark: '230011',
                           check_digit: '7', individual_number: '00002' }
      expect(response).to have_http_status(201)

      get :index, params: { tag: 'UK230011700002' }
      expect(response).to have_http_status(200)

      delete :destroy, params: { tag: 'UK230011700002' }
      expect(response).to have_http_status(200)

      get :index, params: { tag: 'UK230011700002' }
      expect(response).to have_http_status(404)
    end
  end
end
