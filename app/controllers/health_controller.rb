class HealthController < ApplicationController
  before_action :authenticate_request!, except: [:index]

  def index
    render json: { status: 'online' }
  end

  def login_placeholder # TODO: Remove
    render json: { user: current_user }
  end
end
