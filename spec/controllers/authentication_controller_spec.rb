require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  before(:all) do
    @email = 'farmerjoe@farming.co.uk'
    @password = 'somelikeitagriculture'
    @user = User.create(
      email: @email,
      password: @password,
      password_confirmation: @password
    )
  end

  before(:each) do
    @email = 'farmerjoe@farming.co.uk'
    @password = 'somelikeitagriculture'
  end

  describe 'Session Management' do
    describe 'POST :new_session' do
      it 'returns a new token for valid user' do
        post :new_session, params: { email: @email, password: @password }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).key?('auth_token')).to be true
      end

      # TODO: more testing here
    end
  end

  describe 'User Management' do
    describe 'GET :show_user' do
      it 'returns user with correct token' do
        request.headers['Authorization'] = "Bearer #{auth_token(@email, @password)}"
        get :show_user
        expect(response).to have_http_status(:success)
      end

      it 'returns unauthorized with no token' do
        get :show_user
        expect(response).to have_http_status(:unauthorized)
      end
    end

    # TODO: New user
  end

  private

  def auth_token(email, password)
    post :new_session, params: { email: email, password: password }
    response_body = JSON.parse(response.body)
    response_body['auth_token']
  end
end
