require 'rails_helper'

RSpec.describe CattleController, type: :controller do
  describe 'GET #show' do
    it 'get unregistered cattle returns http error' do
      get :show, params: { tag: 'UK230011700002' }
      expect(response).to have_http_status(:not_found)
    end

    it 'get registered cattle successfully returns cattle information' do
      tag = Tag.create!(
        country_code: 'UK', herdmark: '230011',
        check_digit: '7', individual_number: '00002'
      )
      Cattle.find_by(tag_id: tag.id).update!(
        name: 'Daisy', breed: 'Wagyu', gender: 'female', dob: Date.today
      )
      get :show, params: { tag: 'UK230011700002' }
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq({ cattle: { tag: 'UK230011700002', name:
        'Daisy', breed: 'Wagyu', gender: 'female', dob: Date.today } }.to_json)
    end

    it 'get deleted cattle returns http error' do
      Tag.create!(
        country_code: 'UK', herdmark: '230011',
        check_digit: '7', individual_number: '00002'
      ).destroy
      get :show, params: { tag: 'UK230011700002' }
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

  describe 'POST #update' do
    it 'post update to unregistered cattle registeres tag then updates cattle info before returning http success ' do
      post :update, params: {
        tag: 'UK230011700002', name: 'Daisy', breed: 'Wagyu',
        gender: 'female', dob: Date.today
      }
      expect(response).to have_http_status(:ok)
    end

    it 'post update to registered cattle updates info returns http success' do
      Tag.create!(
        country_code: 'UK', herdmark: '230011',
        check_digit: '7', individual_number: '00002'
      )
      post :update, params: {
        tag: 'UK230011700002', name: 'Daisy', breed: 'Wagyu',
        gender: 'female', dob: Date.today
      }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE #destroy' do
    it 'delete unregistered cattle returns http error' do
      delete :destroy, params: { tag: 'UK230011700002' }
      expect(response).to have_http_status(:not_found)
    end

    it 'delete registered cattle returns http success' do
      Tag.create!(
        country_code: 'UK', herdmark: '230011',
        check_digit: '7', individual_number: '00002'
      )
      delete :destroy, params: { tag: 'UK230011700002' }
      expect(response).to have_http_status(:ok)
    end
  end
end
