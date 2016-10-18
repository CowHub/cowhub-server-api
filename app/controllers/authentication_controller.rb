class AuthenticationController < ApplicationController
  before_filter :authenticate_request!, except: [:new_user, :new_session]

  # USER REGISTRATION
  def new_user
    user = User.find_for_database_authentication(email: params[:email])
    unless user
      user = User.create(
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      )
      if user.valid?
        new_token_id(user)
        render json: payload(user), status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :bad_request
      end
      return
    end
    render json: { errors: ['User already exists!'] }, status: :conflict
  end

  def show_user
    render json: { user: current_user }, status: :ok
  end

  # USER SESSION
  def new_session
    user = User.find_for_database_authentication(email: params[:email])
    if user.valid_password?(params[:password])
      new_token_id(user)
      render json: payload(user)
    else
      render json: { errors: ['Invalid Username/Password'] }, status: :unauthorized
    end
  end

  private

  def new_token_id(user)
    user.token_id = rand(10_000_000)
    user.save && user
  end

  def payload(user)
    return nil unless user && user.id
    {
      auth_token: JsonWebToken.encode(id: user.id, token_id: user.token_id),
      user: { id: user.id, email: user.email }
    }
  end
end
