class ImageController < ApplicationController
  before_filter :authenticate_request!

  def index
    cattle = current_user.cattle.find_by(id: params[:id])
    if cattle
      render json: {
        images: cattle.image
      }, status: :ok
    else
      render json: {
        errors: ['Cattle not found']
      }, status: :not_found
    end
  end

  def upload
  end

  def verify
  end
end
