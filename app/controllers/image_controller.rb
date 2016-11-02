class ImageController < ApplicationController
  before_action :authenticate_request!

  def index
    cattle = current_user.cattle.find_by(id: params[:id])
    if cattle
      render json: {
        images: cattle.image
      }, status: :ok
    else
      render json: {}, status: :not_found
    end
  end

  def upload
    cattle = current_user.cattle.find_by(id: params[:id])
    if cattle
      image = cattle.image.create(image_uri: params[:data])
      if image.valid?
        image.save
        render json: { image: image }, status: :ok
      else
        render json: { errors: image.errors.full_messages }, status: :bad_request
      end
    else
      render json: {}, status: :not_found
    end
  end

  def verify
    images = Image.where(image_uri: params[:data])
    cattle = []
    images && images.each do |i|
      cattle.push(i.cattle)
    end
    render json: { cattle: cattle }, status: :ok
  end
end
