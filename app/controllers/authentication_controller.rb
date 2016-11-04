class AuthenticationController < ApplicationController
  before_action :authenticate_request!, except: [:new_user, :new_session]

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
  def validate_session
    user = User.find_by(auth_token)
    render json: {}, status: user ? :ok : :unauthorized
  end

  def new_session
    user = User.find_for_database_authentication(email: params[:email])
    unless user
      render json: { errors: ['User does not exist'] }, status: :unauthorized
      return
    end
    if user.valid_password?(params[:password])
      render json: payload(user), status: :ok
    else
      render json: { errors: ['Invalid Username/Password'] }, status: :unauthorized
    end
  end

  def end_session
    if current_user
      current_user.token = nil
      current_user.save
      render json: {}, status: :ok
    else
      render json: {}, status: :unauthorized
    end
  end

  private

  def payload(user)
    return nil unless user && user.id
    {
      auth_token: user.generate_token,
      user: { id: user.id, email: user.email }
    }
  end
end
