require 'rails_helper'

RSpec.describe CattleController, type: :controller do
  before(:all) do
    @email = 'farmerjoe@farming.co.uk'
    @password = 'somelikeitagriculture'
    @user = User.find_by(email: @email)
    unless @user
      @user = User.create(
        email: @email,
        password: @password,
        password_confirmation: @password
      )
    end
    @auth_token = @user.generate_token
  end

  before(:each) do
    @request.headers['Authorization'] = "Bearer #{@auth_token}"
  end

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

  describe 'POST #search' do
    before(:all) do
      @cattle1 = { tag: 'UK230011700001', name: nil, breed: nil, gender: nil, dob: nil }
      @cattle2 = { tag: 'UK230011500002', name: nil, breed: nil, gender: nil, dob: nil }
      @cattle3 = { tag: 'UK230042700003', name: nil, breed: nil, gender: nil, dob: nil }
      @cattle4 = { tag: 'FR230011700002', name: nil, breed: nil, gender: nil, dob: nil }
    end

    it 'patch update to unregistered cattle returns http error' do
      Cattle.create!(
        country_code: 'UK', herdmark: '230011',
        check_digit: '7', individual_number: '00001'
      )
      Cattle.create!(
        country_code: 'UK', herdmark: '230011',
        check_digit: '5', individual_number: '00002'
      )
      Cattle.create!(
        country_code: 'UK', herdmark: '230042',
        check_digit: '7', individual_number: '00003'
      )
      Cattle.create!(
        country_code: 'FR', herdmark: '230011',
        check_digit: '7', individual_number: '00002'
      )
      post :search, params: { country_code: 'UK', herdmark: '230011' }
      expect(response.body).to eq({ cattle: [@cattle1, @cattle2] }.to_json)
      post :search, params: { country_code: 'UK' }
      expect(response.body).to eq({ cattle: [@cattle1, @cattle2, @cattle3] }.to_json)
      post :search, params: { check_digit: 7 }
      expect(response.body).to eq({ cattle: [@cattle1, @cattle3, @cattle4] }.to_json)
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

  describe 'POST #match' do
    before(:all) do
      @data = 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQABLAEsAAD/4QCMRXhpZgAAT\
        TU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAA\
        BAAIAAIdpAAQAAAABAAAAWgAAAAAAAAEsAAAAAQAAASwAAAABAAOgAQADAAAAAQABAACgAg\
        AEAAAAAQAAAU+gAwAEAAAAAQAAAOYAAAAA/'
    end

    it 'post match unregistered cattle imprint returns http error' do
      post :match, params: { imprint: @data }
      expect(response).to have_http_status(:not_found)
    end

    it 'post match registered cattle imprint returns http success' do
      cattle = Cattle.create!(
        country_code: 'UK', herdmark: '230011',
        check_digit: '7', individual_number: '00002',
        name: 'Daisy', breed: 'Wagyu', gender: 'female', dob: Date.today
      )
      post :upload_imprint, params: { id: cattle.id, imprint: @data }
      post :match, params: { imprint: @data }
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq({ cattle: { tag: 'UK230011700002', name:
        'Daisy', breed: 'Wagyu', gender: 'female', dob: Date.today } }.to_json)
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
