require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  before(:suite) do
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
  end

  private

  def auth_token(email, password)
    post :new_session, params: { email: email, password: password }
    response.body['auth_token']
  end
end
