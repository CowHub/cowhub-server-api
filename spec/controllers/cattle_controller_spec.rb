require 'rails_helper'

RSpec.describe CattleController, type: :controller do
  describe 'GET #show' do
    it 'get unregistered cattle returns http error' do
      get :show, params: { id: '42' }
      expect(response).to have_http_status(:not_found)
    end

    it 'get registered cattle successfully returns cattle information' do
      cattle = Cattle.create!(
        country_code: 'UK', herdmark: '230011',
        check_digit: '7', individual_number: '00002',
        name: 'Daisy', breed: 'Wagyu', gender: 'female', dob: Date.today
      )
      get :show, params: { id: cattle.id }
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq({ cattle: { tag: 'UK230011700002', name:
        'Daisy', breed: 'Wagyu', gender: 'female', dob: Date.today } }.to_json)
    end

    it 'get deleted cattle returns http error' do
      cattle = Cattle.create!(
        country_code: 'UK', herdmark: '230011',
        check_digit: '7', individual_number: '00002'
      )
      id = cattle.id
      cattle.destroy
      get :show, params: { id: id }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #new' do
    it 'post registration of unregistered tags returns http success' do
      post :new, params: {
        country_code: 'UK', herdmark: '230011', check_digit: '7',
        individual_number: '00002'
      }
      expect(response).to have_http_status(:created)
    end

    it 'post complete registration of unregistered tags returns http success' do
      post :new, params: {
        country_code: 'UK', herdmark: '230011', check_digit: '7',
        individual_number: '00002', name: 'Daisy', breed: 'Wagyu',
        gender: 'female', dob: Date.today
      }
      expect(response).to have_http_status(:created)
      expect(response.body).to eq({ cattle: { tag: 'UK230011700002', name:
        'Daisy', breed: 'Wagyu', gender: 'female', dob: Date.today } }.to_json)
    end

    it 'post registration of already registered tags returns http error' do
      post :new, params: {
        country_code: 'UK', herdmark: '230011', check_digit: '7',
        individual_number: '00002'
      }
      post :new, params: {
        country_code: 'UK', herdmark: '230011', check_digit: '7',
        individual_number: '00002'
      }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'PATCH #update' do
    it 'patch update to unregistered cattle returns http error' do
      patch :update, params: {
        id: '42', name: 'Daisy', breed: 'Wagyu',
        gender: 'female', dob: Date.today
      }
      expect(response).to have_http_status(:not_found)
    end

    it 'patch update to registered cattle updates info returns http success' do
      cattle = Cattle.create!(
        country_code: 'UK', herdmark: '230011',
        check_digit: '7', individual_number: '00002'
      )
      patch :update, params: {
        id: cattle.id, name: 'Daisy', breed: 'Wagyu',
        gender: 'female', dob: Date.today
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
      cattle = Cattle.create!(
        country_code: 'UK', herdmark: '230011',
        check_digit: '7', individual_number: '00002'
      )
      delete :destroy, params: { id: cattle.id }
      expect(response).to have_http_status(:ok)
    end
  end
end
