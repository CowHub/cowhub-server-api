class HealthController < ApplicationController
  before_action :authenticate_request!, except: [:index]

  def index
    render json: { status: 'online' }
  end
end
