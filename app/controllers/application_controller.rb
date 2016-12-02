class ApplicationController < ActionController::API
  attr_reader :current_user

  protected

  def authenticate_request!
    errors = ['Not Authenticated']
    token = auth_token
    unless token
      render json: { errors: errors }, status: :unauthorized
      return
    end
    @current_user = User.find_by(token)
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: errors }, status: :unauthorized
  end

  private

  def http_token
    @http_token ||=
      if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end
end
