class AuthenticationController < ApplicationController
  def new_user
    user = User.find_for_database_authentication(email: params[:email])
    unless user
      user = User.create(
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      )
      if user.valid?
        user.save
        render json: payload(user), status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :bad_request
      end
      return
    end
    render json: { errors: ['User already exists!'] }, status: :conflict
  end

  def new_session
    user = User.find_for_database_authentication(email: params[:email])
    if user.valid_password?(params[:password])
      render json: payload(user)
    else
      render json: { errors: ['Invalid Username/Password'] }, status: :unauthorized
    end
  end

  private

  def payload(user)
    return nil unless user && user.id
    {
      auth_token: JsonWebToken.encode(user_id: user.id),
      user: { id: user.id, email: user.email }
    }
  end
end
