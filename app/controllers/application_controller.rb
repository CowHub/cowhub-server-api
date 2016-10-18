class ApplicationController < ActionController::API
  attr_reader :current_user

  protected

  def authenticate_request!
    auth_token_ = auth_token
    unless auth_token_
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end
    @current_user = User.find_by(auth_token_)
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  private

  def http_token
    @http_token ||=
      if request.headers['Authorization'].present?
        puts request.headers['Authorization']
        request.headers['Authorization'].split(' ').last
      end
  end

  def auth_token
    puts http_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end
end
